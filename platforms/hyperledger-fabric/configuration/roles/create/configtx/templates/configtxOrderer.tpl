Orderer: &OrdererDefaults
  OrdererType: {{ consensus.name }}
  Addresses:
{% for orderer in orderers %}
    - {{orderer.name}}.{{ item.external_url_suffix }}:8443
{% endfor %}
  BatchTimeout: 2s
  BatchSize:
    MaxMessageCount: 10
    AbsoluteMaxBytes: 98 MB
    PreferredMaxBytes: 1024 KB
{% if consensus.name == 'kafka' %}
  Kafka:
    Brokers:
{% for i in range(consensus.replicas) %}
      - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ component_ns }}.svc.cluster.local:{{ consensus.grpc.port }}
{% endfor %}
{% endif %}
  Organizations:
  Capabilities:
    <<: *OrdererCapabilities