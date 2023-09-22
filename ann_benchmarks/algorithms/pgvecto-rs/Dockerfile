FROM ann-benchmarks

# https://github.com/pgvector/pgvector/blob/master/Dockerfile

RUN git clone https://github.com/tensorchord/pgvecto.rs.git /tmp/pgvector

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata lsb-release wget

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && apt-get install -y --no-install-recommends build-essential postgresql-15 postgresql-server-dev-all postgresql-contrib libpq-dev libssl-dev pkg-config gcc libreadline-dev flex bison libxml2-dev libxslt-dev libxml2-utils xsltproc zlib1g-dev ccache clang curl cargo

RUN cd /tmp/pgvector

RUN curl -y --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN apt-get update
#RUN cargo install cargo-pgrx --git https://github.com/tensorchord/pgrx.git --rev $(cat Cargo.toml | grep "pgrx =" | awk -F'rev = "' '{print $2}' | cut -d'"' -f1)
RUN cargo install cargo-pgrx --git https://github.com/tensorchord/pgrx.git --rev c0d11a8b78b0d707a5e9106bc4d5f66395ca9a2e --locked
RUN export PATH=/root/.cargo/bin:$PATH
RUN cargo pgrx init --pg15=/usr/lib/postgresql/15/bin/pg_config
RUN cargo pgrx install --release

RUN sh -c 'echo "local all all trust" > /etc/postgresql/15/main/pg_hba.conf'
#	git config pull.ff only && \
#	git checkout hnsw && \
#	git pull && \
#	make clean && \
#	make OPTFLAGS="-march=native" && \
#	make install && \
RUN	rm -R /tmp/pgvector

USER postgres
RUN service postgresql start && \
    psql -c 'ALTER SYSTEM SET shared_preload_libraries = "vectors.so"' && \
    service postgresql stop

RUN service postgresql start && \
    psql -c "CREATE USER ann WITH ENCRYPTED PASSWORD 'ann'" && \
    psql -c "CREATE DATABASE ann" && \
    psql -c "GRANT ALL PRIVILEGES ON DATABASE ann TO ann" && \
    psql -d ann -c "CREATE EXTENSION pg_prewarm" && \
    psql -d ann -c "CREATE EXTENSION vectors" && \
    psql -c "ALTER USER ann SET maintenance_work_mem = '16GB'"
USER root

RUN pip install psycopg[binary] pgvector
