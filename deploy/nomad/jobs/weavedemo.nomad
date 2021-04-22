job "weavedemo" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "10s"
    max_parallel = 1
  }

  # - frontend #
  group "frontend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - frontend app - #
    task "front-end" {
      driver = "docker"

      config {
        image = "weaveworksdemos/front-end"
        hostname = "front-end.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-front-end"
        tags = ["frontend", "front-end"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128MB
        network {
          mbits = 10
        }
      }
    }
    # - end frontend app - #

    # - edge-router - #
    task "edgerouter" {
      driver = "docker"

      config {
        image = "weaveworksdemos/edge-router"
        hostname = "edge-router.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
        port_map = {
          http = 80
          https = 443
        }
      }

      service {
        name = "${TASKGROUP}-edgerouter"
        tags = ["router", "edgerouter"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128MB
        network {
          mbits = 10
          port "http" {
            static = 80
          }
          port "https" {
            static = 443
          }
        }
      }
    } # - end edge-router - #
  } # - end frontend - #

  # - user - #
  group "user" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "user" {
      driver = "docker"

      config {
        image = "weaveworksdemos/user"
        hostname = "user.weave.local"
        network_mode = "secure"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-user"
        tags = ["user"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    } # - end app - #

    # - db - #
    task "user-db" {
      driver = "docker"

      config {
        image = "weaveworksdemos/user-db"
        hostname = "user-db.weave.local"
        network_mode = "secure"
      }

      service {
        name = "${TASKGROUP}-userdb"
        tags = ["db", "user", "userdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 96 # 96MB
        network {
          mbits = 10
        }
      }
    } # - end db - #
  } # - end user - #

  # - catalogue - #
  group "catalogue" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "catalogue" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue"
        hostname = "catalogue.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-catalogue"
        tags = ["catalogue"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 32MB
        network {
          mbits = 10
        }
      }
    } # - end app - #

    # - db - #
    task "cataloguedb" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue-db"
        hostname = "catalogue-db.weave.local"
        network_mode = "external"
      }

      env {
        MYSQL_DATABASE = "socksdb"
        MYSQL_ROOT_PASSWORD = ""
        MYSQL_ALLOW_EMPTY_PASSWORD = "true"
      }

      service {
        name = "${TASKGROUP}-cataloguedb"
        tags = ["db", "catalogue", "cataloguedb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }

    } # - end db - #
  } # - end catalogue - #

  # - carts - #
  group "carts" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "carts" {
      driver = "docker"

      config {
        image = "weaveworksdemos/carts"
        hostname = "carts.weave.local"
        network_mode = "internal"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-carts"
        tags = ["carts"]
      }
      
      env {
        JAVA_OPTS = "-Xms64m -Xmx128m -XX:PermSize=32m -XX:MaxPermSize=64m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom"
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 1024 # 1024MB
        network {
          mbits = 10
        }
      }
    } # - end app - #

    # - db - #
    task "cartdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "carts-db.weave.local"
        network_mode = "internal"
      }

      service {
        name = "${TASKGROUP}-cartdb"
        tags = ["db", "carts", "cartdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    } # - end db - #
  } # - end carts - #

  # - shipping - #
  group "shipping" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "shipping" {
      driver = "docker"

      config {
        image = "weaveworksdemos/shipping"
        hostname = "shipping.weave.local"
        network_mode = "backoffice"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-shipping"
        tags = ["shipping"]
      }

      env {
        JAVA_OPTS = "-Xms64m -Xmx128m -XX:PermSize=32m -XX:MaxPermSize=64m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom"
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 1024 # 1024MB
        network {
          mbits = 10
        }
      }
    } # - end app - #
  } # - end shipping - #

  # - payment - #
  group "payment" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "payment" {
      driver = "docker"

      config {
        image = "weaveworksdemos/payment"
        hostname = "payment.weave.local"
        network_mode = "secure"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-payment"
        tags = ["payment"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 16 # 16MB
        network {
          mbits = 10
        }
      }
    } # - end app - #
  } # - end payment - #


  # - orders - #
  group "orders" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - app - #
    task "orders" {
      driver = "docker"

      config {
        image = "weaveworksdemos/orders"
        hostname = "orders.weave.local"
        network_mode = "internal"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-orders"
        tags = ["orders"]
      }

      env {
        JAVA_OPTS = "-Xms64m -Xmx128m -XX:PermSize=32m -XX:MaxPermSize=64m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom"
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 1024 # 1024MB
        network {
          mbits = 10
        }
      }
    } # - end app - #

    # - db - #
    task "ordersdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "orders-db.weave.local"
        network_mode = "internal"
      }

      service {
        name = "${TASKGROUP}-orders"
        tags = ["db", "orders", "ordersdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 64 # 64MB
        network {
          mbits = 10
        }
      }
    } # - end db - #
  } # - end orders - #

  # - queue-master #
  group "queue-master" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - queue-master app - #
    task "queue-master" {
      driver = "raw_exec"

      config {
        command = "/usr/bin/docker"
        args = ["run", "--name", "queue-master-${NOMAD_ALLOC_ID}", "--volume", "/var/run/docker.sock:/var/run/docker.sock", "--restart", "always", "--dns", "172.17.0.1", "--dns-search", "weave.local.", "--net", "backoffice", "--hostname", "queue-master.weave.local", "weaveworksdemos/queue-master"]
      }

      service {
        name = "${TASKGROUP}-container"
        tags = ["queuemaster"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    } # - end queue-master app - #
  } # - end queue-master - #

  # - rabbitmq - #
  group "rabbitmq" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - proc - #
    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:3.6.8"
        hostname = "rabbitmq.weave.local"
        network_mode = "backoffice"
      }

      service {
        name = "${TASKGROUP}-rabbitmq"
        tags = ["db"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 160 # 160MB
        network {
          mbits = 10
        }
      }
    } # - end proc - #
  } # - end rabbitmq - #
}
