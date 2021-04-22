job "logging-elk" {
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  # - logging-elk - #
  group "elasticsearch" {

    # - elasticsearch - #
    task "logging-elk-elasticsearch" {
      driver = "docker"

      env {
        "discovery.type" = "single-node"
      }
      config {
        image              = "docker.elastic.co/elasticsearch/elasticsearch:7.6.1"
        hostname           = "elasticsearch.weave.local"
        network_mode       = "external"
        dns_servers        = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
        logging {
          type = "json-file"
        }
      }

      resources {
        memory = 2000
        network {
          mbits = 50
        }
      }

    }
    # - end elasticsearch - #
    # - end kibana - #

  } # - end logging-elk - #

  group "kibana" {

    # - kibana - #
    task "logging-elk-kibana" {
      driver = "docker"

      config {
        image              = "docker.elastic.co/kibana/kibana:7.6.1"
        hostname           = "kibana.weave.local"
        network_mode       = "external"
        dns_servers        = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
        port_map {
          kibana = 5601
        }
        logging {
          type = "json-file"
        }
      }

      resources {
        memory = 1000
        network {
          mbits = 50
          port "kibana" {
            static = "5601"
          }
        }
      }

    }
    # - end kibana - #

  # } # - end logging-elk - #  

}
