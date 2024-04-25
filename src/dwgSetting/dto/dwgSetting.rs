use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Setting {
    pub keynum: String,
    pub title: String,
    pub description: String,
    pub dwg: String,
    pub json: String,
    pub instim: String,
    pub cnltim: String,
}
