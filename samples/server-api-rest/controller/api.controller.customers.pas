{******************************************************************************}
{                                                                              }
{  Server REST API Sample with Delphi MVC Framework                            }
{  Copyright (c) 2020 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/server-api-rest }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}

unit api.controller.customers;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  // Caso não use essa unit o carregamento do swagger não fica correto
  MVCFramework.Swagger.Commons,
  api.core.common,
  // Caso não use essa unit será compilado, mas dará o erro no carregamento do Swagger
  // Erro swagger: Failed to load spec.
  api.model.customers;

const
  SWAGGER_USERS_GROUP = 'Customers';

type

  [MVCPath('/customers')]
  [MVCSwagAuthentication(atJsonWebToken)]
  [MVCRequiresAuthentication]
  TCustomersController = class(TMVCController)
  public
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary(SWAGGER_USERS_GROUP, 'Returns all customers list.')]
    [MVCSwagResponses(HTTP_STATUS.OK, API_MSG_RESPONSE_SUCCESS_200, TCustomer, True)]
    [MVCSwagResponses(HTTP_STATUS.Unauthorized, API_MSG_RESPONSE_ERROR_401)]
    procedure GetCustomers;

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary(SWAGGER_USERS_GROUP, 'Returns a customer data.')]
    [MVCSwagParam(plPath, 'id', 'Customer id', ptInteger)]
    [MVCSwagResponses(HTTP_STATUS.OK, API_MSG_RESPONSE_SUCCESS_200, TCustomer)]
    [MVCSwagResponses(HTTP_STATUS.Unauthorized, API_MSG_RESPONSE_ERROR_401)]
    [MVCSwagResponses(HTTP_STATUS.NotFound, API_MSG_RESPONSE_ERROR_404)]
    procedure GetCustomer(const id: Int64);

    [MVCPath('')]
    [MVCHTTPMethod([httpPOST])]
    [MVCSwagSummary(SWAGGER_USERS_GROUP, 'Creates a new customer.')]
    [MVCSwagParam(plBody, 'entity', 'Customer object', TCustomerBasic)]
    [MVCSwagResponses(HTTP_STATUS.Created, API_MSG_RESPONSE_SUCCESS_201, TCustomer)]
    [MVCSwagResponses(HTTP_STATUS.Unauthorized, API_MSG_RESPONSE_ERROR_401)]
    procedure CreateCustomer;

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpPUT])]
    [MVCSwagSummary(SWAGGER_USERS_GROUP, 'Updates a customer.')]
    [MVCSwagParam(plPath, 'id', 'Customer id', ptInteger)]
    [MVCSwagParam(plBody, 'entity', 'Customer object', TCustomerBasic)] // o nome da classe aqui não exige o uses.
    [MVCSwagResponses(HTTP_STATUS.OK, API_MSG_RESPONSE_SUCCESS_200, TCustomer)]
    [MVCSwagResponses(HTTP_STATUS.Unauthorized, API_MSG_RESPONSE_ERROR_401)]
    [MVCSwagResponses(HTTP_STATUS.NotFound, API_MSG_RESPONSE_ERROR_404)]
    procedure UpdateCustomer(const id: Int64); // o nome do parâmetro aqui deve ser o mesmo definido em path. [MVCPath('/($id)')]

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    [MVCSwagSummary(SWAGGER_USERS_GROUP, 'Removes a customer.')]
    [MVCSwagParam(plPath, 'id', 'Customer id', ptInteger)]
    [MVCSwagResponses(HTTP_STATUS.NoContent, API_MSG_RESPONSE_SUCCESS_204)]
    [MVCSwagResponses(HTTP_STATUS.Unauthorized, API_MSG_RESPONSE_ERROR_401)]
    [MVCSwagResponses(HTTP_STATUS.NotFound, API_MSG_RESPONSE_ERROR_404)]
    procedure DeleteCustomer(const id: Int64);
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  //MVCFramework.Logger,
  MVCFramework.Controllers.Register;

//Sample CRUD Actions for a "Customer" entity

procedure TCustomersController.GetCustomers;
begin
  Self.Render<TCustomer>(TCustomers.ReturnCustomersList, True); //memory leak?
end;

procedure TCustomersController.GetCustomer(const id: Int64);
begin
  Self.Render(TCustomers.ReturnCustomer(id), True); //memory leak?
end;

procedure TCustomersController.CreateCustomer;
begin
  var vCustomer := Context.Request.BodyAs<TCustomer>;
  try
    TCustomers.Insert(vCustomer);
    Self.Render(vCustomer, False); { Returns the customer object to the response }
  finally
    vCustomer.Free;
  end;
end;

procedure TCustomersController.UpdateCustomer(const id: Int64);
begin
  var vCustomer := Context.Request.BodyAs<TCustomer>;
  try
    vCustomer.id := id;
    TCustomers.Update(vCustomer);
    Self.Render(vCustomer, False);
  finally
    vCustomer.Free;
  end;
end;

procedure TCustomersController.DeleteCustomer(const id: Int64);
begin
  TCustomers.Delete(id);
  Self.Render(HTTP_STATUS.NoContent, API_MSG_RESPONSE_SUCCESS_204);
end;

initialization
  TControllersRegister.Instance.RegisterController(TCustomersController, API_SERVER_NAME);

end.
