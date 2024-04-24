FROM ruby:3.1

# установка библиотек для работы приложения (сейчас отсутствуют)
RUN apt-get update -qq && apt-get install -y locales

# установка локали, чтобы испльзовать русский в консоли внутри контейнера
RUN echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen ru_RU.UTF-8 && \
  /usr/sbin/update-locale LANG=ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

ENV APP_PATH=/usr/src
WORKDIR $APP_PATH

# устаналиваем гемы, необходимые приложению
COPY Gemfile* $APP_PATH/
RUN bundle install

# копируем код приложения
COPY . .

# сообщаем другим разработчикам и devopsам о том, на каком порту работает наше приложение
EXPOSE 4000

# устанавливаем команду по умолчанию
CMD ["rails", "server", "-b", "0.0.0.0"]