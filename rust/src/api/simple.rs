use std::collections::HashMap;
use age::secrecy::ExposeSecret;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn create_key() -> HashMap<String, String> {
    let key = age::x25519::Identity::generate();
    
    // generate a combo of public and private key in a map
    let mut key_map = HashMap::new();
    key_map.insert("public_key".to_string(), key.to_public().to_string());
    key_map.insert("private_key".to_string(), key.to_string().expose_secret().to_string());
    // return the map directly
    key_map
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
