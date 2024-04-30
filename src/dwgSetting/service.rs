use crate::db::dwgSetting::*;
use crate::dwgSetting::dto::dwgSetting::Setting;
use crate::dwgSetting::dto::dwgSetting::UploadSetting;
use crate::dwgSetting::dto::response::dwgSettingsResponseData;

use actix_web::http::StatusCode;
use derive_more::{Display, Error, From};

#[derive(Debug, Display, Error, From)]
pub enum dwgSettingError {
    MysqlError(mysql::Error),
    Unknown,
}

impl actix_web::ResponseError for dwgSettingError {
    fn status_code(&self) -> StatusCode {
        match self {
            dwgSettingError::MysqlError(_) | dwgSettingError::Unknown => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

pub fn get_all_dwgSetting(pool: &mysql::Pool, column: String, order: bool) -> Result<dwgSettingsResponseData, dwgSettingError> {
    let mut conn = pool.get_conn()?;

    Ok(dwgSettingsResponseData {
        dwgSettings: query::select_settings(&mut conn, column, order)?
            .iter()
            .map(|DwgSetting| Setting {
                keynum: DwgSetting.keynum.clone(),
                title: DwgSetting.title.clone(),
                description: DwgSetting.description.clone(),
                dwg: DwgSetting.dwg.clone(),
                json: DwgSetting.json.clone(),
                instim: DwgSetting.instim.clone(),
                cnltim: DwgSetting.cnltim.clone(),
            })
            .collect::<Vec<Setting>>(),
    })
}

pub fn create_dwgSetting(pool: &mysql::Pool, upload: UploadSetting) -> Result<(), dwgSettingError> {
    let mut conn = pool.get_conn()?;
    query::post_dwgSetting(&mut conn, upload.title, upload.description, upload.dwg, upload.json)?;
    Ok(())
}

pub fn put_dwgSetting(pool: &mysql::Pool, key: String, title: String, description: String, res: i32) -> Result<(), dwgSettingError> {
    let mut conn = pool.get_conn()?;
    query::put_dwgSetting(&mut conn, key, title, description, res)?;
    Ok(())
}

pub fn delete_dwgSetting(pool: &mysql::Pool, key: String) -> Result<(), dwgSettingError> {
    let mut conn = pool.get_conn()?;
    query::delete_dwgSetting(&mut conn, key)?;
    Ok(())
}