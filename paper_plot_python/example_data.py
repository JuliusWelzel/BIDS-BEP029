import numpy as np
from scipy.signal import find_peaks
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# quick plot
dat = pd.read_table(r"walk.csv", delimiter=';')


n_sam = len(dat.AccX)
time = np.linspace(0,n_sam / 100, n_sam)
peaks, _ = find_peaks(dat.AccZ,height=40)

plt.figure(figsize=(8, 8))
sns.set_palette("rocket")
sns.lineplot(time, dat.AccX, label='lf_acc_x')
sns.lineplot(time, dat.AccY, label='lf_acc_z')
sns.lineplot(time, dat.AccZ, label='lf_acc_z')
plt.vlines(time[peaks],-80,80,colors=[0,0,0],linestyles='dotted')
plt.vlines(time[peaks[0]],-80,80,colors=[0,0,0],linestyles='dotted', label='heel strike')
plt.xlabel('Time [s]')
plt.ylabel('Acceleration [m/s²]')
plt.ylim([-40, 60])
plt.xlim([0,9])
plt.legend()
plt.show()

