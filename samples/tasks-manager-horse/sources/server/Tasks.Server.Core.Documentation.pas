{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Documentation;

interface

uses
  System.JSON,
  Json.Schema,
  Swag.Doc,
  Swag.Doc.Path,
  Swag.Doc.Path.Operation,
  Swag.Doc.Path.Operation.Response;

type
  /// <summary>
  /// Writes the OpenAPI 3 document of the API with SwagDoc. The routes are registered in Horse by the
  /// Tasks.Server.Core.Routes unit and documented here with the same paths.
  /// </summary>
  TApiDocumentation = class sealed(TObject)
  strict private
    const
      c_TasksTagName = 'Tasks';
      c_AuthenticationTagName = 'Authentication';
      c_SecuritySchemeName = 'bearerAuth';
      c_MimeTypeJson = 'application/json';

      c_TaskSchemaName = 'task';
      c_TaskStatusSchemaName = 'taskStatus';
      c_TaskListSchemaName = 'taskList';
      c_CredentialSchemaName = 'credential';
      c_TokenSchemaName = 'token';

      c_LoginRoute = '/login';
      c_TasksRoute = '/tasks';
      c_TaskRoute = '/tasks/{id}';
      c_TaskStatusRoute = '/tasks/{id}/status';

    class procedure DocumentInfo(pSwagDoc: TSwagDoc); static;
    class procedure DocumentServers(pSwagDoc: TSwagDoc); static;
    class procedure DocumentTags(pSwagDoc: TSwagDoc); static;
    class procedure DocumentSecurity(pSwagDoc: TSwagDoc); static;
    class procedure DocumentSchemas(pSwagDoc: TSwagDoc); static;

    class procedure DocumentLogin(pSwagDoc: TSwagDoc); static;
    class procedure DocumentTasks(pSwagDoc: TSwagDoc); static;
    class procedure DocumentTask(pSwagDoc: TSwagDoc); static;
    class procedure DocumentTaskStatus(pSwagDoc: TSwagDoc); static;

    class function TaskSchema: TJsonSchema; static;
    class function TaskStatusSchema: TJsonSchema; static;
    class function CredentialSchema: TJsonSchema; static;
    class function TokenSchema: TJsonSchema; static;

    class procedure AddSchema(pSwagDoc: TSwagDoc; const pName: string; pSchema: TJsonSchema); overload; static;
    class procedure AddSchema(pSwagDoc: TSwagDoc; const pName, pJsonSchema: string); overload; static;
    class function AddResponse(pOperation: TSwagPathOperation; const pStatusCode,
      pDescription: string): TSwagResponse; static;
    class procedure AddContentResponse(pOperation: TSwagPathOperation; const pStatusCode, pDescription,
      pSchemaName: string); static;
    class procedure AddIdParameter(pPath: TSwagPath); static;
    class procedure AddFlagParameter(pOperation: TSwagPathOperation; const pName, pDescription: string); static;
    class procedure AddRequestBody(pOperation: TSwagPathOperation; const pDescription,
      pSchemaName: string); static;
    class procedure AddSecurity(pOperation: TSwagPathOperation); static;
  public
    /// <summary>
    /// Documents the whole API in the given document.
    /// </summary>
    class procedure DocumentApi(pSwagDoc: TSwagDoc); static;
  end;

implementation

uses
  System.SysUtils,
  Json.Schema.Field.Strings,
  Json.Schema.Field.Numbers,
  Swag.Common.Types,
  Swag.Doc.Tags,
  Swag.Doc.Definition,
  Swag.Doc.SecurityDefinitionHttp,
  Swag.Doc.SecurityRequirement,
  Swag.Doc.Path.Operation.RequestBody,
  Swag.Doc.Path.Operation.RequestParameter,
  Horse.SwagDoc;

{ TApiDocumentation }

class procedure TApiDocumentation.DocumentApi(pSwagDoc: TSwagDoc);
begin
  DocumentInfo(pSwagDoc);
  DocumentServers(pSwagDoc);
  DocumentTags(pSwagDoc);
  DocumentSecurity(pSwagDoc);
  DocumentSchemas(pSwagDoc);

  DocumentLogin(pSwagDoc);
  DocumentTasks(pSwagDoc);
  DocumentTask(pSwagDoc);
  DocumentTaskStatus(pSwagDoc);
end;

class procedure TApiDocumentation.DocumentInfo(pSwagDoc: TSwagDoc);
begin
  pSwagDoc.Info.Title := 'Tasks API';
  pSwagDoc.Info.Version := 'v1';
  pSwagDoc.Info.Summary := 'Task management API.';
  pSwagDoc.Info.Description := 'The API aims to manage information about tasks.';
  pSwagDoc.Info.Contact.Name := 'Marcelo Jaloto';
  pSwagDoc.Info.Contact.Email := 'marcelojaloto@gmail.com';
  pSwagDoc.Info.Contact.Url := 'https://github.com/marcelojaloto';
  pSwagDoc.Info.License.Name := 'Apache License - Version 2.0, January 2004';
  pSwagDoc.Info.License.Identifier := 'Apache-2.0';
end;

class procedure TApiDocumentation.DocumentServers(pSwagDoc: TSwagDoc);
begin
  pSwagDoc.AddServer('http://localhost:9000/api', 'Local server');
end;

class procedure TApiDocumentation.DocumentTags(pSwagDoc: TSwagDoc);
var
  vTag: TSwagTag;
begin
  vTag := TSwagTag.Create;
  vTag.Name := c_AuthenticationTagName;
  vTag.Description := 'Generates the token used by the other operations.';
  pSwagDoc.Tags.Add(vTag);

  vTag := TSwagTag.Create;
  vTag.Name := c_TasksTagName;
  vTag.Description := 'Operations on the tasks.';
  pSwagDoc.Tags.Add(vTag);
end;

class procedure TApiDocumentation.DocumentSecurity(pSwagDoc: TSwagDoc);
var
  vBearer: TSwagSecurityDefinitionHttp;
begin
  vBearer := TSwagSecurityDefinitionHttp.Create;
  vBearer.SchemeName := c_SecuritySchemeName;
  vBearer.Scheme := 'bearer';
  vBearer.BearerFormat := 'JWT';
  vBearer.Description := 'Token generated by the login operation, sent in the Authorization header.';
  pSwagDoc.SecurityDefinitions.Add(vBearer);
end;

class procedure TApiDocumentation.DocumentSchemas(pSwagDoc: TSwagDoc);
begin
  AddSchema(pSwagDoc, c_TaskSchemaName, TaskSchema);
  AddSchema(pSwagDoc, c_TaskStatusSchemaName, TaskStatusSchema);
  AddSchema(pSwagDoc, c_CredentialSchemaName, CredentialSchema);
  AddSchema(pSwagDoc, c_TokenSchemaName, TokenSchema);

  AddSchema(pSwagDoc, c_TaskListSchemaName,
    '{"type":"object","description":"Result of the list operation.","properties":' +
    '{"list":{"type":"array","description":"Result with entire task list.",' +
    '"items":{"$ref":"#/components/schemas/' + c_TaskSchemaName + '"}},' +
    '"count":{"type":"integer","format":"int64","description":"Result with the total number of tasks."},' +
    '"averagePending":{"type":"number","description":"Result with the average priority of pending tasks."},' +
    '"countDoneLast7days":{"type":"integer","format":"int64",' +
    '"description":"Result with the number of tasks done in the last 7 days."}}}');
end;

class function TApiDocumentation.TaskSchema: TJsonSchema;
var
  vId: TJsonFieldString;
  vTitle: TJsonFieldString;
  vNotes: TJsonFieldString;
  vStatus: TJsonFieldInteger;
  vPriority: TJsonFieldInteger;
begin
  Result := TJsonSchema.Create;
  Result.Root.Description := 'A task of the manager';

  vId := TJsonFieldString(Result.AddField<string>('id', 'Task identification code.'));
  vId.Required := True;
  vId.MinLength := 36;
  vId.MaxLength := 36;

  vTitle := TJsonFieldString(Result.AddField<string>('title', 'Task title description.'));
  vTitle.Required := True;
  vTitle.MaxLength := 100;

  vNotes := TJsonFieldString(Result.AddField<string>('notes', 'Task notes descriptions.'));
  vNotes.MaxLength := 1000;

  Result.AddField<TDateTime>('createdDate', 'Task created date.');
  Result.AddField<TDateTime>('endDate', 'Task end date.');

  vStatus := TJsonFieldInteger(Result.AddField<Integer>('status',
    'Task status: 0 pending, 1 doing, 2 cancelled, 3 done.'));
  vStatus.Required := True;
  vStatus.MinValue := 0;
  vStatus.MaxValue := 3;

  vPriority := TJsonFieldInteger(Result.AddField<Integer>('priority',
    'Task priority: 0 none, 1 low, 2 medium, 3 high, 4 urgent.'));
  vPriority.Required := True;
  vPriority.MinValue := 0;
  vPriority.MaxValue := 4;
end;

class function TApiDocumentation.TaskStatusSchema: TJsonSchema;
var
  vStatus: TJsonFieldInteger;
begin
  Result := TJsonSchema.Create;
  Result.Root.Description := 'The status of a task';

  vStatus := TJsonFieldInteger(Result.AddField<Integer>('status',
    'Task status: 0 pending, 1 doing, 2 cancelled, 3 done.'));
  vStatus.Required := True;
  vStatus.MinValue := 0;
  vStatus.MaxValue := 3;
end;

class function TApiDocumentation.CredentialSchema: TJsonSchema;
var
  vUsername: TJsonFieldString;
  vPassword: TJsonFieldString;
begin
  Result := TJsonSchema.Create;
  Result.Root.Description := 'The credential of the user';

  vUsername := TJsonFieldString(Result.AddField<string>('username', 'The user name.'));
  vUsername.Required := True;

  vPassword := TJsonFieldString(Result.AddField<string>('password', 'The user password.'));
  vPassword.Required := True;
  vPassword.Format := 'password';
end;

class function TApiDocumentation.TokenSchema: TJsonSchema;
begin
  Result := TJsonSchema.Create;
  Result.Root.Description := 'The token used by the operations of the API';

  Result.AddField<string>('token', 'The generated token.');
  Result.AddField<TDateTime>('createdAt', 'The moment the token was generated.');
  Result.AddField<TDateTime>('expirateAt', 'The moment the token expires.');
end;

class procedure TApiDocumentation.DocumentLogin(pSwagDoc: TSwagDoc);
var
  vOperation: TSwagPathOperation;
begin
  vOperation := pSwagDoc.Route(c_LoginRoute).AddOperation(ohvPost);
  vOperation.OperationId := 'login';
  vOperation.Summary := 'Generates the authentication token';
  vOperation.Description := 'The token returned here is used by all the task operations.';
  vOperation.Tags.Add(c_AuthenticationTagName);

  AddRequestBody(vOperation, 'The credential of the user.', c_CredentialSchemaName);
  AddContentResponse(vOperation, '200', 'The generated token', c_TokenSchemaName);
  AddResponse(vOperation, '400', 'The credential was not accepted');
end;

class procedure TApiDocumentation.DocumentTasks(pSwagDoc: TSwagDoc);
var
  vPath: TSwagPath;
  vOperation: TSwagPathOperation;
begin
  vPath := pSwagDoc.Route(c_TasksRoute);

  vOperation := vPath.AddOperation(ohvGet);
  vOperation.OperationId := 'listTasks';
  vOperation.Summary := 'List of all tasks';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddFlagParameter(vOperation, 'list_all', 'Lists entire the tasks. Uses true or false.');
  AddFlagParameter(vOperation, 'count', 'Gets the total number of tasks. Uses true or false.');
  AddFlagParameter(vOperation, 'average_pending',
    'Gets the average priority of pending tasks. Uses true or false.');
  AddFlagParameter(vOperation, 'count_done_last_7days',
    'Gets the number of tasks done in the last 7 days. Uses true or false.');
  AddContentResponse(vOperation, '200', 'Task list', c_TaskListSchemaName);

  vOperation := vPath.AddOperation(ohvPost);
  vOperation.OperationId := 'createTask';
  vOperation.Summary := 'Create a new task';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddRequestBody(vOperation, 'Task data.', c_TaskSchemaName);
  AddContentResponse(vOperation, '201', 'The created task', c_TaskSchemaName);
  AddResponse(vOperation, '400', 'The task data was not accepted');
end;

class procedure TApiDocumentation.DocumentTask(pSwagDoc: TSwagDoc);
var
  vPath: TSwagPath;
  vOperation: TSwagPathOperation;
begin
  vPath := pSwagDoc.Route(c_TaskRoute);
  AddIdParameter(vPath);

  vOperation := vPath.AddOperation(ohvGet);
  vOperation.OperationId := 'getTask';
  vOperation.Summary := 'Get data for a specific task';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddContentResponse(vOperation, '200', 'Task data', c_TaskSchemaName);
  AddResponse(vOperation, '404', 'The task was not found');

  vOperation := vPath.AddOperation(ohvPut);
  vOperation.OperationId := 'updateTask';
  vOperation.Summary := 'Change data for a specific task';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddRequestBody(vOperation, 'Task data.', c_TaskSchemaName);
  AddResponse(vOperation, '204', 'The task was updated');
  AddResponse(vOperation, '400', 'The task data was not accepted');
  AddResponse(vOperation, '404', 'The task was not found');

  vOperation := vPath.AddOperation(ohvDelete);
  vOperation.OperationId := 'deleteTask';
  vOperation.Summary := 'Delete task';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddResponse(vOperation, '204', 'The task was deleted');
  AddResponse(vOperation, '400', 'The task cannot be deleted');
  AddResponse(vOperation, '404', 'The task was not found');
end;

class procedure TApiDocumentation.DocumentTaskStatus(pSwagDoc: TSwagDoc);
var
  vPath: TSwagPath;
  vOperation: TSwagPathOperation;
begin
  vPath := pSwagDoc.Route(c_TaskStatusRoute);
  AddIdParameter(vPath);

  vOperation := vPath.AddOperation(ohvPatch);
  vOperation.OperationId := 'updateTaskStatus';
  vOperation.Summary := 'Change task status for a specific task';
  vOperation.Tags.Add(c_TasksTagName);
  AddSecurity(vOperation);
  AddRequestBody(vOperation, 'Task status.', c_TaskStatusSchemaName);
  AddResponse(vOperation, '204', 'The status was updated');
  AddResponse(vOperation, '400', 'The status was not accepted');
  AddResponse(vOperation, '404', 'The task was not found');
end;

class procedure TApiDocumentation.AddSchema(pSwagDoc: TSwagDoc; const pName: string; pSchema: TJsonSchema);
var
  vDefinition: TSwagDefinition;
begin
  try
    vDefinition := TSwagDefinition.Create;
    vDefinition.Name := pName;
    vDefinition.JsonSchema := pSchema.ToJson;
    pSwagDoc.Definitions.Add(vDefinition);
  finally
    pSchema.Free;
  end;
end;

class procedure TApiDocumentation.AddSchema(pSwagDoc: TSwagDoc; const pName, pJsonSchema: string);
var
  vDefinition: TSwagDefinition;
begin
  vDefinition := TSwagDefinition.Create;
  vDefinition.Name := pName;
  vDefinition.JsonSchema := TJSONObject.ParseJSONValue(pJsonSchema) as TJSONObject;
  pSwagDoc.Definitions.Add(vDefinition);
end;

class function TApiDocumentation.AddResponse(pOperation: TSwagPathOperation; const pStatusCode,
  pDescription: string): TSwagResponse;
begin
  Result := TSwagResponse.Create;
  Result.StatusCode := pStatusCode;
  Result.Description := pDescription;
  pOperation.Responses.Add(pStatusCode, Result);
end;

class procedure TApiDocumentation.AddContentResponse(pOperation: TSwagPathOperation; const pStatusCode,
  pDescription, pSchemaName: string);
begin
  AddResponse(pOperation, pStatusCode, pDescription).AddMediaType(c_MimeTypeJson).Schema.Name := pSchemaName;
end;

class procedure TApiDocumentation.AddIdParameter(pPath: TSwagPath);
var
  vParameter: TSwagRequestParameter;
begin
  vParameter := pPath.Parameters[0];
  vParameter.Description := 'Task Id.';
  vParameter.Format := 'uuid';
end;

class procedure TApiDocumentation.AddFlagParameter(pOperation: TSwagPathOperation; const pName,
  pDescription: string);
var
  vParameter: TSwagRequestParameter;
begin
  vParameter := TSwagRequestParameter.Create;
  vParameter.Name := pName;
  vParameter.InLocation := rpiQuery;
  vParameter.TypeParameter := stpBoolean;
  vParameter.Description := pDescription;
  pOperation.Parameters.Add(vParameter);
end;

class procedure TApiDocumentation.AddRequestBody(pOperation: TSwagPathOperation; const pDescription,
  pSchemaName: string);
begin
  pOperation.RequestBody.Description := pDescription;
  pOperation.RequestBody.Required := True;
  pOperation.RequestBody.AddMediaType(c_MimeTypeJson).Schema.Name := pSchemaName;
end;

class procedure TApiDocumentation.AddSecurity(pOperation: TSwagPathOperation);
var
  vRequirement: TSwagSecurityRequirement;
begin
  vRequirement := pOperation.AddSecurityRequirement;
  vRequirement.AddScheme(c_SecuritySchemeName, []);
end;

end.
