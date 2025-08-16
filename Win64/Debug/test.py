import pandas as pd
from sklearn.datasets import load_iris
from sklearn.cluster import KMeans

iris = load_iris()

distortion = {}

for i in range(2, 100):
  kmeans = KMeans(init='random',n_clusters=i)
  kmeans.fit(iris.data)
  distortion[i] = kmeans.inertia_

pd.Series(distortion).plot.line()
