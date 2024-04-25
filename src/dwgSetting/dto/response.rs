use crate::dwgSetting::dto::dwgSetting::Setting;
use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct dwgSettingsResponseData {
    pub dwgSettings: Vec<Setting>,
}
