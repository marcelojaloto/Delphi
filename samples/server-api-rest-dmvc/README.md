**********************************************************************************
 Embarcadero Conference 2020 - Online
 (pt-br) Implemente uma API REST Completa com Delphi MVC Framework
 Implement a full API REST with Delphi MVC Framework
 by Marcelo Jaloto
**********************************************************************************
 Server API - version 1.0.0 - 64bits
 Default user: admin
 Default password: 123
 
 DMVCFramework - version 3.2.0 (boron)
 
 Database Postgres - version 12 - 64bits
 Database settings in the file:
 .\deploy\db\Connection.ini
 Attention: Use alias name DB_SAMPLE in the connection settings (Connection.ini).
 Database Postgres drivers folder:
 .\deploy\db\lib
 
 SwagDoc - version with OpenAPI 3 support
 REST API Documentation - OpenAPI 3.2.1
 Swagger UI 5 deploy folder:
 .\deploy\www\api\help

## OpenAPI 3 documentation

The document published at `/api/help/swagger.json` is written as OpenAPI 3.2.1. The web module asks the
Swagger middleware for it:

```delphi
FMVC.AddMiddleware(TMVCSwaggerMiddleware.Create(FMVC,
  TApiDocumentation.GetHeaderInformation('v1.0.0'),
  '/api/help/swagger.json',
  'Authentication JWT',
  False,
  ssvOpenAPI3));
```

DelphiMVCFramework 3.5 publishes the document with that parameter, which defaults to `ssvSwagger2`. This sample
keeps the copy of the framework it was written for, version 3.2.0 (boron), so the parameter and the bundled
SwagDoc were backported into `components\dmvc`: the middleware asks SwagDoc for the OpenAPI 3 document and
declares the token as an HTTP bearer scheme, which lets the Authorize dialog of Swagger UI take the raw token.
The attributes of the controllers did not change.
 
 Command to starts in other server API port:
 ServerRestAPI start 8088
**********************************************************************************
