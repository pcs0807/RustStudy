use crate::dwgSetting::service;
use actix_web::{get, post, put, delete, web, HttpResponse, Responder};

#[derive(Debug, serde::Deserialize)]
pub struct QueryParams {
    sortRule: String,
    asc: bool,
}

#[get("/dwgSettings")]
pub async fn get_dwgSettings(data: web::Data<mysql::Pool>, query_params: web::Query<QueryParams>) -> actix_web::Result<impl Responder> {
    let column = query_params.sortRule.clone();
    let order = query_params.asc;

    let dwgSettings = web::block(move || service::get_all_dwgSetting(&data, column, order)).await??;
    Ok(web::Json(dwgSettings))
}

#[post("/dwgSettings")]
pub async fn post_dwgSettings(
    data: web::Data<mysql::Pool>,
    dwgsetting: web::Json<crate::dwgSetting::dto::dwgSetting::Setting>,
) -> actix_web::Result<impl Responder> {
    web::block(move || service::create_dwgSetting(&data, dwgsetting.into_inner())).await??;
    Ok(HttpResponse::Created())
    
}

#[put("/dwgSettings")]
pub async fn put_dwgSettings(
    data: web::Data<mysql::Pool>,
    keynum: String,
) -> actix_web::Result<impl Responder> {
    web::block(move || service::put_dwgSetting(&data, keynum)).await??;
    Ok(HttpResponse::Created())
    
}

#[delete("/dwgSettings")]
pub async fn delete_dwgSettings(
    data: web::Data<mysql::Pool>,
    keynum: String,
) -> actix_web::Result<impl Responder> {
    web::block(move || service::delete_dwgSetting(&data, keynum)).await??;
    Ok(HttpResponse::Created())
}



/*
#[post("/member")]
pub async fn post_member(
    data: web::Data<mysql::Pool>,
    member: web::Json<crate::member::dto::member::Setting>,
) -> actix_web::Result<impl Responder> {
    web::block(move || service::create_member(&data, member.into_inner())).await??;
    Ok(HttpResponse::Created())
}
 */