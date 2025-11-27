output "user_ids" {
  description = "Map of usernames to user IDs"
  value = {
    for username, u in aws_connect_user.this :
    username => u.user_id
  }
}
