from __future__ import division
from campusfeed_crawler import CampusFeedCrawler
from utility import Utility
import collections
import csv
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
    list_of_post_lengths = CharCounter.get_list_of_post_lengths(posts)
    cnt = collections.Counter(list_of_post_lengths)
    f = 'post_lengths.csv'
    Utility.write_dict_to_file(cnt, f)


if __name__ == '__main__':
    main()