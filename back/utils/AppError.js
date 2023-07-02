export class AppError {
  code;
  message;

  constructor(code, message = "") {
    this.code = code;
    this.message = message;
  }
}
