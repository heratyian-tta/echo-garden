def index
  @garden = current_user.favorite_garden
end
