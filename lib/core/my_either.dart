

class MyEither<T,K> {
  T data;
  K error;

  MyEither(this.data,this.error);
}