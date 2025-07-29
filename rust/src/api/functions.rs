use age::secrecy::ExposeSecret;
use crate::api::types::AgeKey;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn create_key() -> AgeKey {
    let key = age::x25519::Identity::generate();
    
    // generate a combo of public and private key
    let public_key = key.to_public().to_string();
    let private_key = key.to_string().expose_secret().to_string();
    
    AgeKey {
        public_key,
        private_key,
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
} 