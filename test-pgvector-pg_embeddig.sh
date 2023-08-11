python3 install.py --algorithm=pgvector
python3 install.py --algorithm=pgvector-hnsw
python3 install.py --algorithm=pg_embedding_hnsw

python3 run.py --dataset dbpedia-openai-angular --algorithm=pgvector --timeout 50000 --runs 3
python3 run.py --dataset dbpedia-openai-angular --algorithm=pgvector-hnsw --timeout 50000 --runs 3
python3 run.py --dataset dbpedia-openai-angular --algorithm=pg_embedding_hnsw --timeout 50000 --runs 3

# TODO make results generated with user permissions
sudo chown -R ubuntu:ubuntu * 

python3 plot.py --dataset dbpedia-openai-angular
