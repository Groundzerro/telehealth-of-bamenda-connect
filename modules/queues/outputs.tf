output "queues" {
  description = "Map of logical queue name to queue details"
  value = {
    for name, q in aws_connect_queue.this :
    name => {
      id   = q.queue_id
      name = q.name
    }
  }
}
