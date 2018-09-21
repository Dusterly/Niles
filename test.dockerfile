FROM swift:4.2
ADD . /src
WORKDIR /src
RUN swift test
