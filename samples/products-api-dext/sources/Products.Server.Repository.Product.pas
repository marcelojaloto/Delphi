{*********************************************************************************}
{                                                                                 }
{ Products API with Dext                                                          }
{ Copyright (c) 2026 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/products-api-dext   }
{                                                                                 }
{*********************************************************************************}
unit Products.Server.Repository.Product;

interface

uses
  System.SyncObjs,
  System.Generics.Collections,
  Products.Server.Model.Product;

type
  /// <summary>
  /// Stores the products of the catalog. Every product returned is a copy owned by the caller, so the catalog can
  /// change while the caller serializes it.
  /// </summary>
  IProductRepository = interface
    ['{6A1F4C2B-83D5-4E97-B0A6-2C5E9D71F348}']

    /// <summary>
    /// Returns the products of the given category, or every product when the category is empty.
    /// </summary>
    function List(const pCategory: string): TArray<TProduct>;

    /// <summary>
    /// Returns the product with the given identifier, or nil when it does not exist.
    /// </summary>
    function Find(const pId: Integer): TProduct;

    /// <summary>
    /// Adds a product and returns it with its identifier.
    /// </summary>
    function Add(const pRequest: TProductRequest): TProduct;

    /// <summary>
    /// Changes the product with the given identifier and returns it, or returns nil when it does not exist.
    /// </summary>
    function Update(const pId: Integer; const pRequest: TProductRequest): TProduct;

    /// <summary>
    /// Removes the product with the given identifier and returns whether it existed.
    /// </summary>
    function Remove(const pId: Integer): Boolean;
  end;

  /// <summary>
  /// Keeps the catalog in memory, protected by a critical section because Dext answers the requests in several
  /// threads. It is registered as a singleton, so every request sees the same catalog.
  /// </summary>
  TProductRepository = class sealed(TInterfacedObject, IProductRepository)
  strict private
    FLock: TCriticalSection;
    FProducts: TObjectList<TProduct>;
    FNextId: Integer;
    function IndexOf(const pId: Integer): Integer;
    function Clone(pProduct: TProduct): TProduct;
    procedure Store(pProduct: TProduct; const pRequest: TProductRequest);
    procedure Seed;
  public
    constructor Create;
    destructor Destroy; override;

    function List(const pCategory: string): TArray<TProduct>;
    function Find(const pId: Integer): TProduct;
    function Add(const pRequest: TProductRequest): TProduct;
    function Update(const pId: Integer; const pRequest: TProductRequest): TProduct;
    function Remove(const pId: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TProductRepository }

constructor TProductRepository.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FProducts := TObjectList<TProduct>.Create(True);
  FNextId := 1;
  Seed;
end;

destructor TProductRepository.Destroy;
begin
  FreeAndNil(FProducts);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TProductRepository.Seed;

  procedure AddProduct(const pName, pCategory: string; const pPrice: Currency; const pStock: Integer);
  var
    vRequest: TProductRequest;
  begin
    vRequest.Name := pName;
    vRequest.Category := pCategory;
    vRequest.Price := pPrice;
    vRequest.Stock := pStock;
    Add(vRequest).Free;
  end;

begin
  AddProduct('Clean Code', 'books', 39.9, 12);
  AddProduct('The Pragmatic Programmer', 'books', 45.5, 7);
  AddProduct('Mechanical Keyboard', 'electronics', 289.0, 3);
end;

function TProductRepository.IndexOf(const pId: Integer): Integer;
var
  vIndex: Integer;
begin
  Result := -1;
  for vIndex := 0 to FProducts.Count - 1 do
    if FProducts[vIndex].Id = pId then
      Exit(vIndex);
end;

function TProductRepository.Clone(pProduct: TProduct): TProduct;
begin
  Result := TProduct.Create;
  Result.Assign(pProduct);
end;

procedure TProductRepository.Store(pProduct: TProduct; const pRequest: TProductRequest);
begin
  pProduct.Name := pRequest.Name.Trim;
  pProduct.Category := pRequest.Category.Trim.ToLower;
  pProduct.Price := pRequest.Price;
  pProduct.Stock := pRequest.Stock;
  pProduct.UpdatedAt := Now;
end;

function TProductRepository.List(const pCategory: string): TArray<TProduct>;
var
  vProducts: TObjectList<TProduct>;
  vProduct: TProduct;
  vCategory: string;
begin
  vCategory := pCategory.Trim.ToLower;
  // The list owns the copies until they are handed to the caller, so none is lost if one of them fails.
  vProducts := TObjectList<TProduct>.Create(True);
  try
    FLock.Enter;
    try
      for vProduct in FProducts do
        if vCategory.IsEmpty or (vProduct.Category = vCategory) then
          vProducts.Add(Clone(vProduct));
    finally
      FLock.Leave;
    end;
    vProducts.OwnsObjects := False;
    Result := vProducts.ToArray;
  finally
    vProducts.Free;
  end;
end;

function TProductRepository.Find(const pId: Integer): TProduct;
var
  vIndex: Integer;
begin
  Result := nil;
  FLock.Enter;
  try
    vIndex := IndexOf(pId);
    if vIndex >= 0 then
      Result := Clone(FProducts[vIndex]);
  finally
    FLock.Leave;
  end;
end;

function TProductRepository.Add(const pRequest: TProductRequest): TProduct;
var
  vProduct: TProduct;
begin
  FLock.Enter;
  try
    vProduct := TProduct.Create;
    try
      vProduct.Id := FNextId;
      Store(vProduct, pRequest);
      FProducts.Add(vProduct);
    except
      vProduct.Free;
      raise;
    end;
    Inc(FNextId);
    Result := Clone(vProduct);
  finally
    FLock.Leave;
  end;
end;

function TProductRepository.Update(const pId: Integer; const pRequest: TProductRequest): TProduct;
var
  vIndex: Integer;
begin
  Result := nil;
  FLock.Enter;
  try
    vIndex := IndexOf(pId);
    if vIndex < 0 then
      Exit;

    Store(FProducts[vIndex], pRequest);
    Result := Clone(FProducts[vIndex]);
  finally
    FLock.Leave;
  end;
end;

function TProductRepository.Remove(const pId: Integer): Boolean;
var
  vIndex: Integer;
begin
  FLock.Enter;
  try
    vIndex := IndexOf(pId);
    Result := vIndex >= 0;
    if Result then
      FProducts.Delete(vIndex);
  finally
    FLock.Leave;
  end;
end;

end.
