
# -*- mode: ruby -*-
require 'yaml'
require 'fileutils'
require 'ipaddr'

# ==================================================
# 1. PARAMETRES DU PROJET
# ==================================================

GROUPE = Integer(ENV.fetch('GROUPE', '10'))
NB_APP = Integer(ENV.fetch('NB_APP', '2'))

# Réseau validé par l'enseignant pour le groupe 10
RESEAU = ENV.fetch('RESEAU', '192.168.65')

# Adaptateur Host-Only créé dans VirtualBox
ADAPTATEUR_HOSTONLY = "VirtualBox Host-Only Ethernet Adapter #2"

# Image Ubuntu et version fixée
BOITE = "bento/ubuntu-24.04"
VERSION = "202404.23.0"

# ==================================================
# 2. VALIDATION DES PARAMETRES
# ==================================================

unless RESEAU.match?(/\A192\.168\.\d{1,3}\z/)
  abort "ERREUR : le réseau doit être au format 192.168.X"
end

octet = RESEAU.split('.').last.to_i

unless (1..254).include?(octet)
  abort "ERREUR : troisième octet invalide"
end

unless GROUPE == 10
  abort "ERREUR : ce fichier est configuré pour le groupe 10"
end

unless (2..10).include?(NB_APP)
  abort "ERREUR : NB_APP doit être compris entre 2 et 10"
end

# Vérification des adresses IP réservées
IP_BDD1 = "#{RESEAU}.31"
IP_BDD2 = "#{RESEAU}.32"
IP_LB1  = "#{RESEAU}.11"

# ==================================================
# 3. DEFINITION DES MACHINES
# ==================================================

NOEUDS = []

# Serveur PostgreSQL principal
NOEUDS << {
  nom: "bdd1",
  ip: IP_BDD1,
  mem: 768,
  role: "bdd"
}

# Serveur PostgreSQL secondaire / réplica
NOEUDS << {
  nom: "bdd2",
  ip: IP_BDD2,
  mem: 768,
  role: "replique"
}

# Serveurs applicatifs
(1..NB_APP).each do |i|
  NOEUDS << {
    nom: "app#{i}",
    ip: "#{RESEAU}.#{20 + i}",
    mem: 512,
    role: "app"
  }
end

# Répartiteur de charge HAProxy
NOEUDS << {
  nom: "lb1",
  ip: IP_LB1,
  mem: 512,
  role: "lb"
}

# ==================================================
# 4. GENERATION DU FICHIER DE CONFIGURATION YAML
# ==================================================

FileUtils.mkdir_p("config")

File.write(
  "config/noeuds.yml",
  NOEUDS.to_yaml
)

# ==================================================
# 5. VERIFICATION DES SCRIPTS
# ==================================================

NOEUDS.each do |n|
  script = "scripts/#{n[:role]}.sh"

  unless File.file?(script)
    abort "ERREUR : script manquant : #{script}"
  end
end

# ==================================================
# 6. CONFIGURATION VAGRANT
# ==================================================

Vagrant.configure("2") do |config|

  config.vm.box = BOITE
  config.vm.box_version = VERSION

  # Définition des machines virtuelles
  NOEUDS.each do |n|

    config.vm.define n[:nom] do |m|

      # Nom de la machine
      m.vm.hostname = n[:nom]

      # Réseau privé du groupe 10
      m.vm.network "private_network",
        ip: n[:ip],
        name: ADAPTATEUR_HOSTONLY

      # Seul le répartiteur expose le port HTTP
      if n[:role] == "lb"
        m.vm.network "forwarded_port",
          guest: 80,
          host: 8080,
          host_ip: "127.0.0.1"
      end

      # Ressources VirtualBox
      m.vm.provider "virtualbox" do |vb|
        vb.memory = n[:mem]
        vb.cpus = 1
      end

      # Provisionnement selon le rôle
      script = "scripts/#{n[:role]}.sh"

      m.vm.provision "shell",
        path: script

    end
  end
end
