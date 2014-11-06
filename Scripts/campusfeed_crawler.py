import json
import urllib2

class CampusFeedCrawler():

    api_url = "http://www.thecampusfeed.com/api/v1/"

    def __init__(self):
        pass

    @staticmethod
    def fetch_posts():
        posts_endpoint = CampusFeedCrawler.api_url + "posts"
        return json.load(urllib2.urlopen(posts_endpoint))
