version: '2.4'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.3.0
    container_name: elasticsearch
    environment:
       http.host: 0.0.0.0
       transport.host: 127.0.0.1
      #- discovery.type=single-node
      #- node.name=aniket
      #- network.host=localhost
      #- discovery.seed_hosts=192.168.75.132,192.168.75.133
      #- cluster.initial_master_node=node-1,node-2
      #- cluster.name=docker-elastic
      #- bootstrap.memory_lock=true
      #- "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - myelastic:/usr/share/elasticsearch/data/:rw
    ports:
      - 9200:9200
      - 9300:9300
    networks:
      - esnet
  kibana:
    image: docker.elastic.co/kibana/kibana:7.3.0
    container_name: kibana
    volumes:
      - myvol3:/usr/share/kibana/data:rw
    environment:
      ELASTICSEARCH_URL: "http://elasticsearch:9200"
    depends_on:
      - elasticsearch
    ports:
      - 5601:5601
    networks:
      - esnet
  logstash:
    image: docker.elastic.co/logstash/logstash:7.3.0
    container_name: logstash
    build: . 
    environment:
      - path.logs:/var/log/logstash    
    #command: bin/logstash -f /usr/share/logstash/pipeline/logstash.conf
    volumes:
      - myvol1:/usr/share/logstash/:rw
      #- "./logstash/config/logstash.yml:/usr/share/logstash/config/:rw"
      #- "./pipeline/:/usr/share/logstash/pipeline/:ro"
    depends_on:
      - elasticsearch
    ports:
      - 5044:5044
    networks:
      - esnet
volumes:
  myelastic:
    driver: local
  myvol3:
    driver: local
  myvol1:
    driver: local
  
networks:
  esnet:
