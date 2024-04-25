use actix_web::{web, App, HttpServer};
mod db;
mod dwgSetting;
#[actix_web::main] // or #[tokio::main]
async fn main() -> std::io::Result<()> {
    let shared_data = web::Data::new(db::conn::create_pool());

    HttpServer::new(move || {
        App::new()
            .app_data(shared_data.clone())
            .service(dwgSetting::controller::get_dwgSettings)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
