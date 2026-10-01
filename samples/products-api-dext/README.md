## Products API

A product catalog REST API written with the [Dext](https://github.com/dotpas/dext) framework and documented with
[SwagDoc](https://github.com/marcelojaloto/SwagDoc), which publishes an OpenAPI 3.2.1 document and renders it
with Swagger UI.


[![PayPal donate button](https://user-images.githubusercontent.com/26885358/62580349-60bd8780-b87c-11e9-901e-425cf2a83671.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AW8TZ2QTDA7K8)

## Business rules

* REST API Server: a service that manages the products of a catalog, kept in memory. The service offers the
  following operations:

a) List the products, optionally filtered by category.

b) Return a product by its identifier.

c) Add a product.

d) Change a product.

e) Remove a product.

f) Details:
- Use of the Dext framework, with a controller that receives its repository by dependency injection;
- Validation of the requests, answered with the problem details of RFC 9457 (`status`, `title`, `detail`);
- JSON with camelCase names, configured in the serializer of Dext;
- OpenAPI 3.2.1 documentation, written with SwagDoc and published by its middleware for Dext.

## Install

a) Dext

Install Dext with TMS Smart Setup or with the packages of its repository, so its sources are in the library path
of the IDE. The sample was written with Delphi 12 and Dext 1.0.

b) SwagDoc

SwagDoc is installed by the [Boss](https://github.com/HashLoad/boss) package manager, in the folder of this sample:

```
boss install
```

The project finds it in `modules\SwagDoc\Source` and `modules\SwagDoc\Integrations\Dext\Source`.

c) Server REST API

Open `sources\products_server.dproj`, build and run it. The console shows:

```
Server running in the port 9000

API Documentation
http://localhost:9000/api/help
```

The operations are answered at `http://localhost:9000/api/products`:

```
curl http://localhost:9000/api/products?category=books
curl -X POST http://localhost:9000/api/products -H "Content-Type: application/json" -d "{\"name\":\"Refactoring\",\"category\":\"books\",\"price\":49.9,\"stock\":5}"
```

d) API documentation in OpenAPI 3

The documentation is published at http://localhost:9000/api/help and the document at
http://localhost:9000/api/help/openapi.json.

Most of the document comes from what the application already tells Dext: the routes of the controller, the
`SwaggerOperation` and `SwaggerResponse` attributes, the type of the request body and the Swagger attributes of
the model. The middleware reads it on the first request and writes the schemas as the serializer of Dext writes
the JSON, with camelCase names and dates as strings. The `SwagLength` and `SwagRange` attributes of SwagDoc add
the limits of the fields.

The `Products.Server.Core.Documentation` unit writes what the attributes of Dext cannot describe: the list
operation, which returns an array and has a query parameter, and the type of the `{id}` route variable.

## Source code

| Unit                                  | Responsibility                                                             |
| ------------------------------------- | -------------------------------------------------------------------------- |
| `products_server.dpr`                 | Configures the serializer and starts the server in the port 9000            |
| `Products.Server.Core.Startup`        | Registers the services and the controllers and publishes the documentation  |
| `Products.Server.Core.Documentation`  | Completes the document with what the attributes do not describe             |
| `Products.Server.Controller.Product`  | The operations of the catalog                                                |
| `Products.Server.Repository.Product`  | The catalog in memory, safe for the threads of the server                    |
| `Products.Server.Model.Product`       | The product, the request body and the problem details                       |
