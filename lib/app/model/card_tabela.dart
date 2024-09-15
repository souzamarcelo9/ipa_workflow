class CardTabela {
  String id = '';
  String title = '';
  String level;
  int? indicatorValue;
  int price;
  String content;
  int ?quantity;
  String tipo;

  CardTabela(
      { this.id = '',
        this.title = '',
        this.level = '',
        this.indicatorValue = 0,
        this.price = 0,
        this.content = '',
        this.quantity = 0,
        this.tipo = ''
      });
}