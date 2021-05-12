class Orders {
  String month;
  String profit;
  String loss;
  String amount;
  
  Orders({
    this.month,
    this.profit,
    this.loss,
    this.amount,
  });

  String getIndex(int index){
    switch(index){
      case 0:
      return month;
      case 1:
      return profit;
      case 2:
      return loss;
      case 3:
      return amount;
    }
    return '';
  }
  
}