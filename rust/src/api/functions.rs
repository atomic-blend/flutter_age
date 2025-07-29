use age::secrecy::ExposeSecret;
use crate::api::types::AgeKey;
use std::str::FromStr;
use std::io::{Read, Write};
use base64::Engine;

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

#[flutter_rust_bridge::frb(sync)]
pub fn encrypt_string(message: String, public_key: String) -> String {
    let recipient = age::x25519::Recipient::from_str(&public_key).unwrap();
    let encryptor = age::Encryptor::with_recipients([&recipient as &dyn age::Recipient].into_iter()).unwrap();
    let mut encrypted = Vec::new();
    let mut writer = encryptor.wrap_output(&mut encrypted).unwrap();
    writer.write_all(message.as_bytes()).unwrap();
    writer.finish().unwrap();
    base64::engine::general_purpose::STANDARD.encode(encrypted)
}

#[flutter_rust_bridge::frb(sync)]
pub fn decrypt_string(ciphertext: String, private_key: String) -> String {
    let identity = age::x25519::Identity::from_str(&private_key).unwrap();
    let encrypted = base64::engine::general_purpose::STANDARD.decode(ciphertext).unwrap();
    let decryptor = age::Decryptor::new(&encrypted[..]).unwrap();
    let mut decrypted = Vec::new();
    let mut reader = decryptor.decrypt([&identity as &dyn age::Identity].into_iter()).unwrap();
    reader.read_to_end(&mut decrypted).unwrap();
    String::from_utf8(decrypted).unwrap()
}

#[flutter_rust_bridge::frb(sync)]
pub fn encrypt_data(data: Vec<u8>, public_key: String) -> Result<String, String> {
    let recipient = age::x25519::Recipient::from_str(&public_key)
        .map_err(|e| format!("Invalid public key: {e}"))?;
    
    // Use age::Encryptor for data encryption
    let encryptor = age::Encryptor::with_recipients([&recipient as &dyn age::Recipient].into_iter())
        .map_err(|e| format!("Failed to create encryptor: {e}"))?;
    
    let mut encrypted = Vec::new();
    let mut encryptor_writer = encryptor.wrap_output(&mut encrypted)
        .map_err(|e| format!("Failed to wrap output: {e}"))?;

    encryptor_writer.write_all(&data)
        .map_err(|e| format!("Encryption failed: {e}"))?;
    encryptor_writer.finish().map_err(|e| format!("Failed to finish encryption: {e}"))?;

    // Return base64 encoded encrypted data
    Ok(base64::engine::general_purpose::STANDARD.encode(encrypted))
}

#[flutter_rust_bridge::frb(sync)]
pub fn decrypt_data(encrypted_data_base64: String, private_key: String) -> Result<Vec<u8>, String> {
    let identity = age::x25519::Identity::from_str(&private_key)
        .map_err(|e| format!("Invalid private key: {e}"))?;
    
    // Decode base64 encrypted data
    let encrypted_data = base64::engine::general_purpose::STANDARD.decode(encrypted_data_base64)
        .map_err(|e| format!("Failed to decode base64: {e}"))?;

    // Use age::Decryptor for data decryption
    let decryptor = age::Decryptor::new(&encrypted_data[..])
        .map_err(|e| format!("Failed to create decryptor: {e}"))?;
    let mut decryptor_reader = decryptor.decrypt([&identity as &dyn age::Identity].into_iter())
        .map_err(|e| format!("Failed to decrypt: {e}"))?;

    let mut decrypted = Vec::new();
    decryptor_reader.read_to_end(&mut decrypted)
        .map_err(|e| format!("Failed to read decrypted data: {e}"))?;

    Ok(decrypted)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
} 