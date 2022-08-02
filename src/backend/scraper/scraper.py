import instaloader

il = instaloader.Instaloader()

username = input("username: ")
password = input("password: ")

il.login(username, password)
il.download_profile(username, profile_pic_only = True)

profile = instaloader.Profile.from_username(il.context, username)
posts = profile.get_posts()
for index, post in enumerate(posts, 1):
    il.download_post(post, target=f"{profile.username}_{index}")
        