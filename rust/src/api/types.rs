use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AgeKey {
    pub public_key: String,
    pub private_key: String,
} 