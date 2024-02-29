FROM ubuntu:22.04

RUN apt-get update

# Install MySQL and PostgreSQL clients
RUN apt-get update -yy && DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-client mysql-client

RUN apt-get -y install make automake libtool pkg-config libaio-dev git

# For MySQL support
RUN apt-get -y install libmysqlclient-dev libssl-dev

# For PostgreSQL support
RUN apt-get -y install libpq-dev

RUN git clone https://github.com/risingwavelabs/sysbench.git sysbench

WORKDIR sysbench
RUN ./autogen.sh
RUN ./configure --with-mysql --with-pgsql
RUN make -j
RUN make install

WORKDIR /root
RUN rm -rf sysbench

ENTRYPOINT sysbench
