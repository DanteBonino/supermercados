%Base de conocimiento:

%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).


%Punto 1:
descuento(arroz(_),1.50).
descuento(salchicas(Marca,_), 0.50):-
    Marca \= vienisima.
descuento(Producto, 2.00):-
    esUnLacteo(Producto),
    esUnQuesoDePrimerOUnaLeche(Producto).
descuento(Producto,Descuento):-
    productoMasCaro(Producto),
    precioUnitario(Producto, Precio),
    Descuento is (Precio * 5)/ 100.

esUnQuesoDePrimerOUnaLeche(Producto):-
    esUnQuesoDePrimera(Producto).
esUnQuesoDePrimerOUnaLeche(Producto):-
    esUnaLeche(Producto).

esUnQuesoDePrimera(lacteo(Marca,queso(_))):-
    primeraMarca(Marca).
esUnaLeche(lacteo(_,leche)).

esUnLacteo(lacteo(_,_)).

productoMasCaro(Producto):-
    precioUnitario(Producto, PrecioMasCaro),
    forall(precioUnitario(_, Precio), PrecioMasCaro >= Precio).

%Punto 2:
compradorCompulsivo(Cliente):-
    compro(Cliente,_,_),
    forall(productoDePrimeraMarcaConDescuento(Producto), compro(Cliente,Producto,_)).

productoDePrimeraMarcaConDescuento(Producto):-
    descuento(Producto,_),
    esDePrimeraMarca(Producto).

esDePrimeraMarca(Producto):-
    marcaProducto(Producto,Marca),
    primeraMarca(Marca).

marcaProducto(lacteo(Marca,_), Marca).
marcaProducto(arroz(Marca), Marca).
marcaProducto(salchicas(Marca,_),Marca).

%Punto 3:
totalAPagar(Cliente,MontoTotal):-
    compro(Cliente,_,_),
    findall(Precio, valorProductoComprado(Cliente,Precio), Precios),
    sum_list(Precios, MontoTotal).

valorProductoComprado(Cliente, Precio):-
    compro(Cliente, Producto, Cantidad),
    valorProductoConDescuento(Producto, Valor),
    Precio is Valor * Cantidad.

valorProductoConDescuento(Producto, Valor):-
    precioUnitario(Producto, Precio),
    findall(Descuento, descuento(Producto, Descuento), Descuentos),
    sum_list(Descuentos, DescuentoTotal),
    Valor is Precio - DescuentoTotal.

clienteFiel(Cliente, Marca):-
    compro(Cliente,Producto,_),
    tipoProducto(Producto, TipoDeProducto),
    produceElTipo(TipoDeProducto, Marca),
    marcaProducto(Producto, Marca).

tipoProducto(lacteo(_,Tipo),lacteo(_,Tipo)).
tipoProducto(arroz(_), arroz(_)).
tipoProducto(salchicas(_,_), salchicas(_,_)).

produceElTipo(lacteo(_,Tipo), Marca):-
    precioUnitario(lacteo(Marca, Tipo),_).
produceElTipo(arroz(Marca), Marca).
produceElTipo(salchicas(Marca,_), Marca):-
    precioUnitario(salchicas(Marca,_),_).

%Punto 5:
dueno(laSerenisima, gandara).
dueno(gandara, vacalin).

provee(Empresa,CosasQueProvee):-
    productoDe(_,Empresa),
    findall(Producto, productoDe(Producto, Empresa), CosasQueProvee).
provee(Empresa, CosasQueProvee):-
    dueno(Empresa, EmpresaHija),
    provee(EmpresaHija, CosasQueProvee).

productoDe(Producto, Marca):-
    precioUnitario(Producto,_),
    marcaProducto(Producto, Marca).

