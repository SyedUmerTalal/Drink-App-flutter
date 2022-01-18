class TableReservation {
  TableReservation({
    this.tableId,
    this.tableName,
    this.seatingCapacity,
  });
  factory TableReservation.fromJson(Map<String, dynamic> json) =>
      TableReservation(
        tableId: json['table_id'],
        tableName: json['table_name'],
        seatingCapacity: json['seating_capacity'],
      );

  String tableId;
  String tableName;
  String seatingCapacity;

  Map<String, dynamic> toJson() => {
        'table_id': tableId,
        'table_name': tableName,
        'seating_capacity': seatingCapacity,
      };
}
