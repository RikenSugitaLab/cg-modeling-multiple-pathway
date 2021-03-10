#!/usr/bin/env python3

# from scipy.interpolate import griddata
from pylab import meshgrid,cm,imshow,contour,clabel,colorbar,axis,title,show,pcolor
from matplotlib.colors import LinearSegmentedColormap
import numpy as np
import matplotlib.mlab as ml
import matplotlib.pyplot as plt

# initial setting
plt.switch_backend('agg')
plt.style.use('ggplot')
plt.rcParams.update({'font.size': 16})

def generate_cmap(colors):
    values = range(len(colors))
    vmax = np.ceil(np.max(values))
    color_list = []
    for v, c in zip(values, colors):
        color_list.append( ( v/ vmax, c) )
    return LinearSegmentedColormap.from_list('custom_cmap', color_list)

# load free energy landscape
x = np.loadtxt("./xxxxx_grid_x.txt")
y = np.loadtxt("./xxxxx_grid_y.txt")
z = np.loadtxt("./xxxxx_matplotlib.pmf")
X, Y = meshgrid(x, y)
interval = np.arange(0, 12, 1)
#interval = np.arange(0, 50, 2)

plt.figure(figsize=(4,3))

# set contour
cm = generate_cmap(["#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff0000"])
c1 = plt.contourf(X, Y, z, interval, cmap=cm)
c2 = plt.contour(c1,interval,colors='k',linewidths=0.3)

# generate color bar
cbar = plt.colorbar(c1)
cbar.set_label("PMF (kcal/mol)")

# plot points
x_cl = 46
y_cl = 111
x_op = 73
y_op = 147
x_int = 65
y_int = 111
#x_int = 53
#y_int = 147

# plot simulation points
#xmd_cl = 47
#ymd_cl = 111
#xmd_op = 73
#ymd_op = 134
#xmd_int = 64
#ymd_int = 153

# plot
plt.xlim([30, 90])
plt.ylim([80, 200])
plt.xticks(np.arange(30,100,20))
plt.yticks(np.arange(80,230,30))
#plt.xticks(fontsize=16)
#plt.xlabel('theta-NMP')
#plt.ylabel('theta-LID')
plt.xlabel(u"$\it\u03b8$$_{NMP}$")
plt.ylabel(u"$\it\u03b8$$_{LID}$")
plt.tight_layout()
plt.scatter(x_cl, y_cl, s=10, color='#000000', zorder=1)
plt.scatter(x_op, y_op, s=10, color='#000000', zorder=1)
plt.scatter(x_int, y_int, s=10, color='#000000', zorder=1)
#plt.scatter(xmd_cl, ymd_cl, s=10, color='#ff0000', zorder=1)
#plt.scatter(xmd_op, ymd_op, s=10, color='#ff0000', zorder=1)
#plt.scatter(xmd_int, ymd_int, s=10, color='#ff0000', zorder=1)
plt.savefig("xxxxx.png",dpi=300)

