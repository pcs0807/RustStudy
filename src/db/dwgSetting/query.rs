use crate::db::dwgSetting::model::DwgSetting;
use crate::db::dwgSetting::model::DesignMaster;
use crate::db::dwgSetting::model::DesignDetail;
use crate::db::dwgSetting::model::FileInfo;
use mysql::{params, prelude::*};

pub fn select_settings(conn: &mut mysql::PooledConn, column: String, order: bool) -> mysql::error::Result<Vec<DwgSetting>> {
    let column_name = match column {
        latest => "dwgInstim",
        name => "dwgTitle",
        _ => "dwgInstim", // 기본값은 dwgInstim으로 설정
    };

    let order_by = match order {
        true => format!("{} ASC", column_name),
        false => format!("{} DESC", column_name),
        _ => format!("{} ASC", column_name), // 기본값은 오름차순으로 설정
    };

    let query = format!(
        "
        SELECT 
            dwgKey, 
            dwgTitle, 
            dwgDescription, 
            dwgFile.fileName AS dwgFileName, 
            jsonFile.fileName AS jsonFileName, 
            dwgInstim, 
            dwgCnltim 
        FROM dwgsetting 
            INNER JOIN 
                (SELECT 
                    fileKey, 
                    fileName, 
                    filePath 
                    FROM dwgsetting 
                    INNER JOIN fileinfo 
                    ON dwgFileKey = fileKey 
                    AND fileCancel = 0 
                    WHERE dwgCancel = 0 LIMIT 1) AS dwgFile 
            ON dwgsetting.dwgFilekey = dwgFile.fileKey 
            INNER JOIN 
                (SELECT 
                    fileKey, 
                    fileName,
                    filePath 
                    FROM dwgsetting 
                    INNER JOIN fileinfo 
                    ON jsonFilekey = fileKey 
                    AND fileCancel = 0 
                    WHERE dwgCancel = 0 LIMIT 1) AS jsonFile 
            ON dwgsetting.jsonFilekey = jsonFile.fileKey
        WHERE dwgcancel = 0
        ORDER BY {};
        ",
        order_by
    );

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
) -> mysql::error::Result<()> {
    conn.exec_drop(
        r"
        INSERT INTO `drawingautomation`.`DwgSetting` (dwgTitle, dwgDescription) VALUES (:dwgTitle, :dwgDescription);
        ",
        params! {
            "dwgTitle" => title,
            "dwgDescription" => description,
        },
    )
}


pub fn put_dwgSetting(
    conn: &mut mysql::PooledConn,
    dwgkeynum : String,
) -> mysql::error::Result<()> {
    conn.exec_drop(
        r"
        INSERT INTO `drawingautomation`.`DwgSetting` (dwgTitle, dwgDescription) VALUES (:dwgTitle, :dwgDescription);
        ",
        params! {
            "dwgTitle" => dwgkeynum,
        },
    )
}

pub fn delete_dwgSetting(
    conn: &mut mysql::PooledConn,
    dwgkeynum : String,
) -> mysql::error::Result<()> {
    conn.exec_drop(
        r"
        INSERT INTO `drawingautomation`.`DwgSetting` (dwgTitle, dwgDescription) VALUES (:dwgTitle, :dwgDescription);
        ",
        params! {
            "dwgTitle" => dwgkeynum,
        },
    )
}

