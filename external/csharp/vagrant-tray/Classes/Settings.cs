fusing System;
using System.Collections.Generic;
using System.IO;
using Hardcodet.Wpf.TaskbarNotification;
using Newtonsoft.Json;

namespace VagrantTray.Classes
{
    public class Settings
    {
        public Settings()
        {
            VagrantBoxes = new List<VagrantBox>();
        }

        public readonly static string Version = "1.0.2.0";

        public string BoxesPath { get; set; }
        public string VagrantPath { get; set; }
        public List<VagrantBox> VagrantBoxes { get; private set; }
        public TaskbarIcon TaskBar { get; set; }

        public bool IsBoxesPathValid()
        {
            return !string.IsNullOrEmpty(BoxesPath) && Directory.Exists(BoxesPath);
        }

        public bool IsVagrantPathValid()
        {
            return !string.IsNullOrEmpty(VagrantPath) && File.Exists(VagrantPath) &&
                   VagrantPath.EndsWith("vagrant.exe", StringComparison.OrdinalIgnoreCase);
        }

        public void LoadVagrantBoxes()
        {

            foreach (var dir in Directory.GetDirectories(BoxesPath))
            {
                if (dir != null && File.Exists(Path.Combine(dir, "Vagrantfile" /* @"0\virtualbox\Vagrantfile" */ )))
                {
                    VagrantBoxes.Add(new VagrantBox
                    {
                        Name = Path.GetFileName(dir),
                        Path = dir
                    });
                }
            }
        }

        public void Load()
        {
            var fileName = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "VagrantTray", "Settings.json");

            if (File.Exists(fileName))
            {
                var loadedSettings = JsonConvert.DeserializeObject<Settings>(File.ReadAllText(fileName));

                BoxesPath = loadedSettings.BoxesPath;
                VagrantPath = loadedSettings.VagrantPath;
            }
        }

        public void Save()
        {
            var fileName = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "VagrantTray", "Settings.json");

            if (!Directory.GetParent(fileName).Exists)
            {
                Directory.GetParent(fileName).Create();
            }

            File.WriteAllText(fileName, JsonConvert.SerializeObject(this));
        }

        public void ShowBalloon(string title, string message, BalloonIcon icon = BalloonIcon.Info)
        {
            TaskBar.ShowBalloonTip(title, message, icon);
        }

        /// <summary>
        ///     This stops the serialization of the VagrantBoxes property to JSON which isn't needed
        /// </summary>
        public bool ShouldSerializeVagrantBoxes()
        {
            return false;
        }

        /// <summary>
        ///     This stops the serialization of the TaskBar property to JSON which isn't needed
        /// </summary>
        public bool ShouldSerializeTaskBar()
        {
            return false;
        }
    }
}