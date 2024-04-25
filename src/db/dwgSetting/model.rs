pub struct DwgSetting {
    pub keynum: String,
    pub title: String,
    pub description: String,
    pub dwg: String,
    pub json: String,
    pub instim: String,
    pub cnltim: String,
}

pub struct DesignMaster {
    pub serial: i32,
    pub keynum: String,
    pub version: String,
    pub instim: String,
    pub cnltim: String,
    pub cancel: bool,
}


pub struct DesignDetail {
    pub serial: i32,
    pub keynum: String,
    pub name: String,
    pub description: String,
    pub value: String,
    pub instim: String,
    pub cnltim: String,
    pub cancel: bool,
}


pub struct FileInfo {
    pub serial: i32,
    pub keynum: String,
    pub name: String,
    pub path: String,
    pub instim: String,
    pub cnltim: String,
    pub cancel: bool,
}