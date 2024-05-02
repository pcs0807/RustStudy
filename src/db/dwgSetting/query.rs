use crate::db::dwgSetting::model::DwgSetting;
use crate::db::dwgSetting::model::DesignMaster;
use crate::db::dwgSetting::model::DesignDetail;
use crate::db::dwgSetting::model::FileInfo;
use mysql::{params, prelude::*};

pub fn select_settings(conn: &mut mysql::PooledConn, column: String, order: bool) -> mysql::error::Result<Vec<DwgSetting>> {

    let query = format!(
        "CALL SELECT_DWGSETTING('', '{}', {})", column, order);

    conn.query_map(
        &query,
        |(keynum, title, description, dwg, json, instim, cnltim)| DwgSetting {  
            keynum: keynum,          
            title: title,
            description: description,
            dwg: dwg,
            json: json,
            instim: instim,
            cnltim: cnltim
        },
    )
}

pub fn select_setting( conn: &mut mysql::PooledConn, key: String) -> mysql::error::Result<Vec<DwgSetting>> {
    let query = format!(
        "CALL SELECT_DWGSETTING({}, '', TRUE)", key);
    
        conn.query_map(
            &query,
            |(keynum, title, description, dwg, json, instim, cnltim)| DwgSetting {  
                keynum: keynum,          
                title: title,
                description: description,
                dwg: dwg,
                json: json,
                instim: instim,
                cnltim: cnltim
            },
        )
}

pub fn post_dwgSetting(
    conn: &mut mysql::PooledConn,
    title: String,
    description: String,
    dwgName: String,
    jsonName: String,
) -> mysql::error::Result<()> {
    let query = "CALL CREATE_DWGSETTING(?, ?, ?, ?)";
    conn.exec_drop(query, (dwgName, jsonName, title, description))
}


pub fn put_dwgSetting(
    conn: &mut mysql::PooledConn,
    key : String,
    title : String,
    description : String,
    result : i32,
) -> mysql::error::Result<()> {
    let query = "CALL UPDATE_DWGSETTING(?, ?, ?, ?)";
    conn.exec_drop(query, (key, title, description, result))
}

pub fn delete_dwgSetting(
    conn: &mut mysql::PooledConn,
    keynum : String,
) -> mysql::error::Result<()> {
    let query = format!("CALL DELETE_DWGSETTING({})", keynum);
    conn.exec_drop(query, ())
}

