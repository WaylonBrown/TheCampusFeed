from __future__ import division
from campusfeed_crawler import CampusFeedCrawler
import collections
import json
import re

class CharCounter(object):

    crawler = CampusFeedCrawler()

    def __init__(self):
        pass

    @staticmethod
    def text_length(json_post):
        return len(str(json_post['text']))

    @staticmethod
    def get_list_of_post_lengths(json_post_list):
        return [CharCounter.text_length(post) for post in json_post_list]

def main():
    posts = CampusFeedCrawler.fetch_posts()
    post_lengths_set = CharCounter.get_list_of_post_lengths(posts)

    print post_lengths_set

if __name__ == '__main__':
    main()