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

    if column != "latest" && column != "name" {
        return Ok(HttpResponse::BadRequest().body("지원하지 않는 정렬 방식입니다."));
    }

    
    let dwgSettings = web::block(move || service::get_all_dwgSetting(&data, column, order)).await??;
    
    Ok(HttpResponse::Ok().json(dwgSettings))
}


#[get("/dwgSettings/{keynum}")]
pub async fn get_dwgSetting(data: web::Data<mysql::Pool>,key: web::Path<String>) -> actix_web::Result<impl Responder> {
    let id = key.into_inner();
    if id.is_empty() {
        return Ok(HttpResponse::BadRequest().body("id정보가 없습니다."));
      }

    if !id.parse::<i32>().is_ok() {
        return Ok(HttpResponse::BadRequest().body("id는 숫자여야 합니다."));
    }

    let dwgSettings = web::block(move || service::get_dwgSetting(&data, id)).await??;
    Ok(HttpResponse::Ok().json(dwgSettings))
}

#[post("/dwgSettings")]
pub async fn post_dwgSetting(
    data: web::Data<mysql::Pool>,
    uploadSet: web::Json<crate::dwgSetting::dto::dwgSetting::UploadSetting>,
) -> actix_web::Result<impl Responder> {

    if uploadSet.dwg.is_empty() {
        return Ok(HttpResponse::BadRequest().body("dwg 파일(parameter: dwg)이 필요합니다."));
    }

    if uploadSet.json.is_empty() {
        return Ok(HttpResponse::BadRequest().body("json 파일(parameter: json)이 필요합니다."));
    }

    if uploadSet.title.is_empty() {
        return Ok(HttpResponse::BadRequest().body("설정 이름(parameter: name)이 필요합니다."));
    }
   
    let dwg = uploadSet.dwg.clone();
    println!("{}",dwg);
    let json = uploadSet.json.clone();
    println!("{}",json);
    match crate::dwgSetting::dto::FileManager::SaveFile(dwg).await {
        Ok(_) => (),
        Err(e) => return Ok(HttpResponse::InternalServerError().body(format!("Failed to save dwg file: {}", e))),
    }

    match crate::dwgSetting::dto::FileManager::SaveFile(json).await {
        Ok(_) => (),
        Err(e) => return Ok(HttpResponse::InternalServerError().body(format!("Failed to save json file: {}", e))),
    }
    
    match web::block(move || service::create_dwgSetting(&data, uploadSet.into_inner())).await {
        Ok(_) => Ok(HttpResponse::Created().body("Resource created")),
        Err(err) => Ok(HttpResponse::InternalServerError().body("데이터베이스 오류."))
    }
}

#[put("/dwgSettings/{keynum}")]
pub async fn put_dwgSetting(
    data: web::Data<mysql::Pool>,
    key: web::Path<String>,
    updateSet: web::Json<crate::dwgSetting::dto::dwgSetting::UpdateSetting>,
) -> actix_web::Result<impl Responder> {
    let keynum = key.into_inner();
    let title = updateSet.title.clone();
    let description = updateSet.description.clone();
    let result = updateSet.result.clone();

    if keynum.is_empty() {
        return Ok(HttpResponse::BadRequest().body("id정보가 없습니다."));
      }

    if !keynum.parse::<i32>().is_ok() {
        return Ok(HttpResponse::BadRequest().body("id는 숫자여야 합니다."));
    }

    if title.is_empty() && description.is_empty() {
        return Ok(HttpResponse::BadRequest().body("변경할 정보가 없습니다. (name, dwg 등)"));
      }

      match web::block(move || service::put_dwgSetting(&data, keynum, title, description, result)).await {
        Ok(_) => Ok(HttpResponse::Created().body("Resource created")),
        Err(err) => Ok(HttpResponse::InternalServerError().body("데이터베이스 오류."))
    }
}

#[delete("/dwgSettings/{keynum}")]
pub async fn delete_dwgSetting(
    data: web::Data<mysql::Pool>,
    key: web::Path<String>
) -> actix_web::Result<impl Responder> {
    let keynum = key.into_inner();

    if keynum.is_empty() {
        return Ok(HttpResponse::BadRequest().body("id정보가 없습니다."));
    }

    if !keynum.parse::<i32>().is_ok() {
        return Ok(HttpResponse::BadRequest().body("id는 숫자여야 합니다."));
    }

    match web::block(move || service::delete_dwgSetting(&data, keynum)).await {
        Ok(_) => Ok(HttpResponse::NoContent().body("Resource created")),
        Err(err) => Ok(HttpResponse::InternalServerError().body("데이터베이스 오류."))
    }

}