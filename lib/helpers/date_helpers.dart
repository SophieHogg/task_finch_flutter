// to be replaced when importing date package

extension renderDate on DateTime {
  String toRenderedDate() {
    return '${this.day}/${this.month}/${this.year} ${this.hour}:${this.minute} ';
  }
}