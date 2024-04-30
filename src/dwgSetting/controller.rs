use crate::dwgSetting::service;
use actix_web::{get, post, put, delete, web, HttpResponse, Responder};

#[derive(Debug, serde::Deserialize)]
pub struct SelectAllParams {
    sortRule: String,
    asc: bool,
}

#[derive(Debug, serde::Deserialize)]
pub struct SelectKey {
    keynum: String,
}

#[get("/dwgSettings")]
pub async fn get_dwgSettings(data: web::Data<mysql::Pool>, query_params: web::Query<SelectAllParams>) -> actix_web::Result<impl Responder> {
    let column = query_params.sortRule.clone();
    let order = query_params.asc;
    let dwgSettings = web::block(move || service::get_all_dwgSetting(&data, column, order)).await??;
    Ok(web::Json(dwgSettings))
}


#[get("/dwgSettings/{keynum}")]
pub async fn get_dwgSetting(data: web::Data<mysql::Pool>,key: web::Path<String>) -> actix_web::Result<impl Responder> {
    let id = key.into_inner();
    let dwgSettings = web::block(move || service::get_dwgSetting(&data, id)).await??;
    Ok(web::Json(dwgSettings))
}

#[post("/dwgSettings")]
pub async fn post_dwgSettings(
    data: web::Data<mysql::Pool>,
    uploadSet: web::Json<crate::dwgSetting::dto::dwgSetting::UploadSetting>,
) -> actix_web::Result<impl Responder> {
    web::block(move || service::create_dwgSetting(&data, uploadSet.into_inner())).await??;
    Ok(HttpResponse::Created())
}

#[put("/dwgSettings")]
pub async fn put_dwgSettings(
    data: web::Data<mysql::Pool>,
    query_params: web::Query<SelectKey>,
    updateSet: web::Json<crate::dwgSetting::dto::dwgSetting::UpdateSetting>,
) -> actix_web::Result<impl Responder> {
    let key = query_params.keynum.clone();
    let title = updateSet.title.clone();
    let description = updateSet.description.clone();
    let result = updateSet.result.clone();
    web::block(move || service::put_dwgSetting(&data, key, title, description, result)).await??;
    Ok(HttpResponse::Created())
}

#[delete("/dwgSettings")]
pub async fn delete_dwgSetting(
    data: web::Data<mysql::Pool>,
    query_params: web::Query<SelectKey>
) -> actix_web::Result<impl Responder> {
    let key = query_params.keynum.clone();
    web::block(move || service::delete_dwgSetting(&data, key)).await??;
    Ok(HttpResponse::NoContent())
}