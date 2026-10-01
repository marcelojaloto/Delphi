{*********************************************************************************}
{                                                                                 }
{ Products API with Dext                                                          }
{ Copyright (c) 2026 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/products-api-dext   }
{                                                                                 }
{*********************************************************************************}
unit Products.Server.Model.Product;

interface

uses
  Dext.OpenAPI.Attributes,
  Swag.Doc.Schema.Attributes;

type
  /// <summary>
  /// A product of the catalog, as it is sent by the API. The Swagger attributes of Dext describe the members and
  /// the SwagLength and SwagRange attributes of SwagDoc add the limits that Dext does not describe.
  /// </summary>
  [SwaggerSchema('Product', 'A product of the catalog')]
  TProduct = class sealed(TObject)
  strict private
    FId: Integer;
    FName: string;
    FCategory: string;
    FPrice: Currency;
    FStock: Integer;
    FUpdatedAt: TDateTime;
  public
    /// <summary>
    /// Copies every member of the given product.
    /// </summary>
    procedure Assign(pSource: TProduct);

    [SwaggerProperty('The product identifier'), SwaggerRequired, SwaggerExample('1')]
    property Id: Integer read FId write FId;

    [SwaggerProperty('The name shown in the catalog'), SwaggerRequired, SwagLength(1, 80)]
    [SwaggerExample('Clean Code')]
    property Name: string read FName write FName;

    [SwaggerProperty('The category used to filter the catalog'), SwaggerRequired, SwaggerExample('books')]
    property Category: string read FCategory write FCategory;

    [SwaggerProperty('The unit price'), SwaggerRequired, SwagRange(0.01, 99999.99), SwaggerExample('39.9')]
    property Price: Currency read FPrice write FPrice;

    [SwaggerProperty('The units in stock'), SwagRange(0, 1000000), SwaggerExample('12')]
    property Stock: Integer read FStock write FStock;

    [SwaggerProperty('The date and time of the last change')]
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
  end;

  /// <summary>
  /// The body of the requests that add or change a product.
  /// </summary>
  [SwaggerSchema('ProductRequest', 'The data of a product sent by the client')]
  TProductRequest = record
    [SwaggerRequired, SwagLength(1, 80), SwaggerExample('Clean Code')]
    Name: string;

    [SwaggerRequired, SwaggerExample('books')]
    Category: string;

    [SwaggerRequired, SwagRange(0.01, 99999.99), SwaggerExample('39.9')]
    Price: Currency;

    [SwagRange(0, 1000000), SwaggerExample('12')]
    Stock: Integer;

    /// <summary>
    /// Returns True when the request can be stored, or False with the reason in pError.
    /// </summary>
    function Validate(out pError: string): Boolean;
  end;

  /// <summary>
  /// The body of the error responses, in the shape of the problem details of RFC 9457.
  /// </summary>
  [SwaggerSchema('Problem', 'The details of an error')]
  TProblem = class sealed(TObject)
  strict private
    FStatus: Integer;
    FTitle: string;
    FDetail: string;
  public
    constructor Create(const pStatus: Integer; const pTitle, pDetail: string); reintroduce;

    [SwaggerRequired, SwaggerExample('404')]
    property Status: Integer read FStatus write FStatus;

    [SwaggerRequired, SwaggerExample('Product not found')]
    property Title: string read FTitle write FTitle;

    [SwaggerExample('There is no product with the identifier 99.')]
    property Detail: string read FDetail write FDetail;
  end;

implementation

uses
  System.SysUtils;

const
  c_MaxNameLength = 80;
  c_MaxPrice = 99999.99;
  c_MaxStock = 1000000;

{ TProduct }

procedure TProduct.Assign(pSource: TProduct);
begin
  FId := pSource.Id;
  FName := pSource.Name;
  FCategory := pSource.Category;
  FPrice := pSource.Price;
  FStock := pSource.Stock;
  FUpdatedAt := pSource.UpdatedAt;
end;

{ TProductRequest }

function TProductRequest.Validate(out pError: string): Boolean;
begin
  pError := EmptyStr;

  if Name.Trim.IsEmpty then
    pError := 'The name is required.'
  else if Name.Trim.Length > c_MaxNameLength then
    pError := Format('The name has more than %d characters.', [c_MaxNameLength])
  else if Category.Trim.IsEmpty then
    pError := 'The category is required.'
  else if (Price <= 0) or (Price > c_MaxPrice) then
    pError := 'The price must be greater than zero and at most 99999.99.'
  else if (Stock < 0) or (Stock > c_MaxStock) then
    pError := Format('The stock must be between 0 and %d.', [c_MaxStock]);

  Result := pError.IsEmpty;
end;

{ TProblem }

constructor TProblem.Create(const pStatus: Integer; const pTitle, pDetail: string);
begin
  inherited Create;
  FStatus := pStatus;
  FTitle := pTitle;
  FDetail := pDetail;
end;

end.
