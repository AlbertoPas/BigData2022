#!/bin/bash

# Import our enriched airline data as the 'airlines' collection
mongoimport -d agile_data_science -c origin_dest_distances --file data/origin_dest_distances.jsonl -u root -p example --authenticationDatabase admin
mongosh agile_data_science --eval 'db.origin_dest_distances.ensureIndex({Origin: 1, Dest: 1})' -u root -p example --authenticationDatabase admin
