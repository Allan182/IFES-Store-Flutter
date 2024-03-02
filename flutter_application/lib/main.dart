import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Produto {
  final String nome;
  final double preco;
  final String descricao;
  final int qtd;
  final List<String> tags;

  const Produto(this.nome, this.preco, this.descricao, this.qtd, this.tags);
}

const listaProdutos = [
  Produto("Lápis", 1.20, "Lápis REGENT 9600 para desenho técnico", 10,
      ["Desenho", "Grafite", "Lápis"]),
  Produto("Borracha", 2.34, "Borracha Castell pure 12", 4,
      ["Desenho", "Corretores", "Lápis"]),
  Produto(
      "Tela para tinta óleo 12 x 30",
      12.50,
      "Tela para pintura a óleo no tamanho 12 x 30 da Pureza",
      8,
      ["Pintura", "Tinta"]),
  Produto(
      "Conjunto de tintas a óleo Watson 12 ",
      1.20,
      "Counto de tintas da Watson com 12 cores, tibos de 90 ml",
      5,
      ["Pintura", "Tinta"]),
  Produto(
      "Régua Linear 50 CM",
      40.12,
      "Régua lienar para quadro/tela tmanho 50cmx 5cm",
      10,
      ["Medidas", "Acessórios"]),
  Produto(
      "Régua Técnica 30 Cm",
      1.20,
      "Régua técnica com medição em CM e Inch com 30 cm x 4 cm",
      3,
      ["Acessórios", "Medidas"]),
];

final List<Produto> _carrinho = [];

void main() {
  runApp(const IfesStore());
}

class IfesStore extends StatelessWidget {
  const IfesStore({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IFES Store",
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({Key? key}) : super(key: key);

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    var c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView.builder(
          itemCount: listaProdutos.length,
          itemBuilder: (BuildContext context, int index) {
            final noCarrinho = _carrinho.contains(listaProdutos[index]);

            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProdutoDetalhe(produto: listaProdutos[index])));
              },
              title: Text(listaProdutos[index].nome),
              subtitle: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: listaProdutos[index]
                    .tags
                    .map((tag) => Chip(label: Text('#$tag')))
                    .toList(),
              ),
              trailing: Text(c.format(listaProdutos[index].preco)),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    if (noCarrinho) {
                      _carrinho.remove(listaProdutos[index]);
                    } else {
                      _carrinho.add(listaProdutos[index]);
                    }
                  });
                },
                icon: noCarrinho
                    ? const Icon(Icons.add_circle, color: Colors.red)
                    : const Icon(Icons.add_circle_outlined),
              ),
            );
          }),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.green,
        child: IconTheme(
            data: IconThemeData(color: Colors.green),
            child: Row(
                children: <Widget>[SizedBox(height: 64), Text('IFES Store')])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_carrinho.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CarrinhoSubTotal(produto: _carrinho)),
              );
            }
          },
          tooltip: 'Carrinho de compras',
          child: Badge(
            label: Text('${_carrinho.length}'),
            child: const Icon(Icons.shopping_basket),
          )),
    );
  }
}

class CarrinhoSubTotal extends StatefulWidget {
  final List<Produto> produto;
  const CarrinhoSubTotal({Key? key, required this.produto}) : super(key: key);

  @override
  CarrinhoSubTotalState createState() => CarrinhoSubTotalState();
}

class CarrinhoSubTotalState extends State<CarrinhoSubTotal> {
  final NumberFormat c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
  List<int> quantidades = [];
  var subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    quantidades = List<int>.filled(_carrinho.length, 1);
  }

  @override
  Widget build(BuildContext context) {
    void calculaSubTotal(List produtos) {
      subtotal = 0.0;
      for (int i = 0; i < produtos.length; i++) {
        subtotal += produtos[i].preco * quantidades[i];
      }
    }

    calculaSubTotal(_carrinho);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: ListView.builder(
        itemCount:_carrinho.length,
        itemBuilder: (BuildContext context, int index) {
          
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProdutoDetalhe(produto: _carrinho[index]),
                ),
              );
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantidades[index] > 1) {
                            quantidades[index]--;
                          }else{
                            _carrinho.remove(_carrinho[index]);
                          }
                        });
                      },
                    ),
                    Text(quantidades[index].toString()),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          if(quantidades[index] >= widget.produto[index].qtd){
                            quantidades[index] = widget.produto[index].qtd;
                            
                          } else {
                             quantidades[index]++;
                          }
                        });
                      },
                    ),
                  ],   
                ),
                Text(widget.produto[index].nome),
                Text(
                    c.format(widget.produto[index].preco * quantidades[index])),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.green,
        child: IconTheme(
          data: const IconThemeData(color: Colors.green),
          child: Row(
            children: <Widget>[
              const SizedBox(height: 64),
              Text('Subtotal: ${c.format(subtotal)}',
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProdutoDetalhe extends StatelessWidget {
  final Produto produto;

  const ProdutoDetalhe({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noCarrinho = _carrinho.contains(produto);
    var c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

    return Scaffold(
        appBar: AppBar(
          title: Text(produto.nome),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(produto.descricao),
            const SizedBox(height: 16),
            Text(c.format(produto.preco)),
            const SizedBox(height: 16),
            noCarrinho ? const Text('No carrinho!') : const Text(''),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: produto.tags
                  .map((tag) => Chip(label: Text('#$tag')))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar')),
          ]),
        ));
  }
}
