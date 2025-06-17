use std::thread;
use std::time::Duration;

use enumflags2::{BitFlag, bitflags};
use hidapi::{HidApi, HidDevice, HidResult};

const VENDOR_ID: u16 = 0x594d;
const PRODUCT_ID: u16 = 0x0075;

const USAGE_PAGE: u16 = 0xFF60;
const USAGE: u16 = 0x61;

#[bitflags]
#[repr(u16)]
#[derive(Copy, Clone, Debug, PartialEq)]
enum Layer {
    Base = 1 << 0,
    Gaming = 1 << 1,
    More = 1 << 2,
    Extra = 1 << 3,
}

fn main() -> anyhow::Result<()> {
    let mut api = HidApi::new()?;

    let mut device: Option<HidDevice> = None;

    loop {
        match &device {
            Some(d) => {
                let mut data = [0u8; 32];
                if d.read(&mut data).is_err() {
                    eprintln!("Device disconnected. Searching for device...");
                    device = None;
                } else {
                    let layers = Layer::from_bits_truncate(u16::from_le_bytes([data[0], data[1]]));

                    let short_layers: String = layers
                        .iter()
                        .map(|x| match x {
                            Layer::Base => "B",
                            Layer::Gaming => "G",
                            Layer::More => "m",
                            Layer::Extra => "e",
                        })
                        .collect();

                    let long_layers: String = layers
                        .iter()
                        .map(|x| match x {
                            Layer::Base => "Base",
                            Layer::Gaming => "Gaming",
                            Layer::More => "more",
                            Layer::Extra => "extra",
                        })
                        .flat_map(|elem| [", ", elem])
                        .skip(1)
                        .collect();

                    println!(
                        r#"{{"text":"{short_layers}", "alt": "none", "tooltip": "{long_layers}", "class": "none"}}"#
                    );
                }
            }
            None => {
                api.reset_devices()?;
                api.add_devices(VENDOR_ID, PRODUCT_ID)?;
                println!(
                    r#"{{"text":"N/A", "alt": "Unknown keyboard state", "tooltip": "none", "class": "none"}}"#
                );

                match api.device_list().find(|device| {
                    device.vendor_id() == VENDOR_ID
                        && device.product_id() == PRODUCT_ID
                        && device.usage_page() == USAGE_PAGE
                        && device.usage() == USAGE
                }) {
                    Some(d) => match api.open_path(d.path()) {
                        Ok(d) => {
                            eprintln!("Device connected");
                            device = Some(d)
                        }
                        Err(e) => {
                            eprintln!("Error connecting to device: {e}");
                            thread::sleep(Duration::from_secs(2));
                        }
                    },
                    None => {
                        thread::sleep(Duration::from_secs(2));
                    }
                }
            }
        }
    }
}
