# encoding: utf-8

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.find_or_create_by(name: "Banco de Tiempo Local") do |org|
end

Organization.find_or_create_by(name: "El otro Banco de Tiempo :)") do |org|
end

User.find_or_create_by(email: "admin@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Manuel Administrador"
  user.date_of_birth = Date.parse("1982-10-12")
  user.phone = "652212383"
  user.alt_phone = "656312313"
  user.description = <<-EOF
  Soy Manuel, tu gestor del Banco de Tiempo estoy aqui para facilitarte la vida, cualquier duda, contacta conmigo"
  EOF
end

User.find_or_create_by(email: "user@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Josep Maria Calastruc"
  user.date_of_birth = Date.parse("1962-01-30")
  user.phone = "712554871"
  user.alt_phone = "932101846"
  user.description = <<-EOF
  Hola nanus, soc supercatala! Viu i deixa viure
  EOF
end

User.find_or_create_by(email: "anna@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Anna Laparra"
  user.date_of_birth = Date.parse("1962-02-05")
  user.phone = "610568452"
  user.description = <<-EOF
  Soy puntual, por favor LLEGA A LA HORA, con amor te lo digo
  EOF
end

User.find_or_create_by(email: "julia@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Julia Alonso"
  user.date_of_birth = Date.parse("1992-06-10")
  user.phone = "682456987"
  user.alt_phone = "934574538"
  user.description = <<-EOF
  Soc molt fort i el meu nom es musculator,...
  EOF
end

User.find_or_create_by(email: "admin2@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Antonia Maria Sala"
  user.date_of_birth = Date.parse("1962-02-05")
  user.phone = "610568452"
  user.description = <<-EOF
  Soy puntual, por favor LLEGA A LA HORA, con amor te lo digo
  EOF
end

User.find_or_create_by(email: "user2@timeoverflow.org") do |user|
  user.terms_accepted_at = DateTime.now.utc
  user.confirmed_at = DateTime.now.utc
  user.password = "1234test"
  user.password_confirmation = "1234test"
  user.username = "Esperanza Andana"
  user.date_of_birth = Date.parse("1992-06-10")
  user.phone = "682456987"
  user.alt_phone = "934574538"
  user.description = <<-EOF
  Soc molt fort i el meu nom es musculator,...
  EOF
end

User.find_by(email: "admin@timeoverflow.org").members.
  find_or_create_by(organization_id: 1) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "user@timeoverflow.org").members.
  find_or_create_by(organization_id: 1) do |member|
  member.manager = false
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "anna@timeoverflow.org").members.
  find_or_create_by(organization_id: 1) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "julia@timeoverflow.org").members.
  find_or_create_by(organization_id: 1) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "admin2@timeoverflow.org").members.
  find_or_create_by(organization_id: 1) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "admin2@timeoverflow.org").members.
  find_or_create_by(organization_id: 2) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

User.find_by(email: "user2@timeoverflow.org").members.
  find_or_create_by(organization_id: 2) do |member|
  member.manager = false
  member.entry_date = DateTime.now.utc
end

unless Category.exists?
  Category.connection.execute "ALTER SEQUENCE categories_id_seq RESTART;"
  [
    "Acompañamiento", "Salud", "Tareas domésticas", "Tareas administrativas",
    "Clases", "Ocio", "Asesoramiento", "Otro"
  ].each do |name|
    unless Category.with_name_translation(name).exists?
      Category.create { |c| c.name = name }
    end
  end
end

Offer.find_or_create_by(title: "Ruby on Rails nivel principiante") do |post|
  post.description = <<-EOF
  Te enseño a trastear un poco sin cuidar el codigo, pero con mucho amor.
  Aprenderas a ser un coder de verdad http://rubyonrails.org/
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Rails", "Ruby", "programación"]
  post.organization_id = 1
end

Offer.find_or_create_by(title: "Cocina low cost") do |post|
  post.description = <<-EOF
  Si **no sabes que puedes comer** y no quieres gastar mucho dinero te enseño como hacer una sopa de plantas silvestres encontradas entre las grietas del asfalto
  EOF
  post.category_id = 7
  post.user_id = 1
  post.tags = ["Cocinar", "Cocina"]
  post.organization_id = 1
end

Offer.find_or_create_by(title: "Yoga para principiantes") do |post|
  post.description = <<-EOF
  Comparteixo les tècniques que he après i he practicat de respiració i meditació (una és inherent a l´altra, l´altra és inherent a l´una).
  En cada sessió: minuts de consciencia postural, cant de mantres, *breu escalfament** (movilització de l´articulacions i la columna vertebral) i una sèrie de PRANAYAMA (respiració) / MEDITACIÓ. Sessions de 1h aprox. *CAPACITACIÓ INTERNACIONAL DE MESTRES DE KUNDALINI IOGA, NIVELL I d’acord Yogi Bhajan. per la “KRI” (KUNDALINI RESEARCH INSTITUT)
  EOF
  post.category_id = 5
  post.user_id = 2
  post.tags = ["Yoga", "Estiramientos", "Respiración", "Meditación"]
  post.organization_id = 1
end

Offer.find_or_create_by(title: "English conversation") do |post|
  post.description = <<-EOF
  Our specially designed courses are for adults looking to improve their proficiency in English. Whether you want to improve your overall communication, take an English exam, or simply want to develop your spoken English skills, we have the right course for you. All successful students will receive a British Council certificate at the end of the course.
  EOF
  post.category_id = 5
  post.user_id = 2
  post.tags = ["Inglés", "English", "Conversación"]
  post.organization_id = 1
end

Offer.find_or_create_by(title: "Te enseño a escribir con Markdown") do |post|
  post.description = <<-EOF
  An h1 header
  ============

  ![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)


  Paragraphs are separated by a blank line.

  2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
  look like:

    * this one
    * that one
    * the other one

  Note that --- not considering the asterisk --- the actual text
  content starts at 4-columns in.

  http://www.google.com 
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Markdown", "programación"]
  post.organization_id = 1
end

Offer.find_or_create_by(title: "Pequeñas reparaciones de casa") do |post|
  post.description = <<-EOF
  Llamame y miramos que necesitas, si veo que puedo ayudarte nos ponemos a ello
  EOF
  post.category_id = 3
  post.user_id = 3
  post.tags = ["casa", "manitas"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Ayuda a organizarme con los tupper") do |post|
  post.description = <<-EOF
  Me cuesta **organizarme con los tupper** me gustaría poder preparar los tupper de toda la semana el domingo, pero para eso necesito consejos y organización ;)
  EOF
  post.category_id = 7
  post.user_id = 1
  post.tags = ["Cocinar", "Cocina", "Tupper"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Quiero aprender a programar") do |post|
  post.description = <<-EOF
  Si, pues eso que me gustaría aprender a programar en Ruby on Rails, de momento solo se hacer copy & paste, me gustaría que alguien se sentara a mi lado para explicarme mejor algunas cosas
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Rails", "Ruby", "programación"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Cocina Tailandesa") do |post|
  post.category_id = 7
  post.user_id = 1
  post.tags = ["Tailandesa", "Cocina"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Cocinar Sushi") do |post|
  post.description = <<-EOF
  Quiero aprender a cocinar sushi del bueno. ![Sushi del bueno](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVixUvEhTshPcin46IJAIDPb8fAjvGH7jcPwbye3ypyVuqqgVD)
  EOF
  post.category_id = 7
  post.user_id = 3
  post.tags = ["Cocinar", "Cocina", "Tupper"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Aprender cocina Libanesa") do |post|
  post.description = <<-EOF
  Humus, falafel, labne, mohamara, kebap y todas estas cosas...
  EOF
  post.category_id = 7
  post.user_id = 3
  post.tags = ["Cocinar", "Cocina", "Tupper"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Conversación en Inglés") do |post|
  post.description = <<-EOF
  Necesito aprendrender ingles urgentemente ya que en dos meses me voy a vivir a Chicago y voy a necesitar inglés fluido
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Inglés", "gramática", "Conversación"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Clases de Italiano") do |post|
  post.description = <<-EOF
  Mi farò prestare un soldino di sole
  perchè regalare lo voglio a te?
  Lo potrai posare sui biondi capelli:
  quella nube d'oro accarezzerò...

  Questa piccolissima serenata
  con un fìl di voce si può cantar?
  Ogni innamorato all'innamorata
  la sussurrerà, la sussurrerà?
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Italiano", "clases", "Conversación"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Alguien que me explique Markdown") do |post|
  post.description = <<-EOF
  No lo entiendo, todo el mundo publica anuncios con imagenes, negritas, cursivas y yo no se hacerlo... alguien me lo explica??
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Markdown"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Quiero hacer Yoga") do |post|
  post.description = <<-EOF
  Me gustaría abrir mis chakras y conectarme con el universo para ser uno con él. Un ser completo y superior. Vamos que quiero ser más flexible.
  EOF
  post.category_id = 5
  post.user_id = 2
  post.tags = ["Yoga", "Estiramientos", "Respiración", "flexibilidad"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Practicar Meditación transcendental") do |post|
  post.description = <<-EOF
  Busco un maestro o un gurú. Paz interior y calma como un lago lleno de peces tranquilos.
  EOF
  post.category_id = 5
  post.user_id = 2
  post.tags = ["Meditación", "Estiramientos", "Respiración", "flexibilidad"]
  post.organization_id = 1
end

Inquiry.find_or_create_by(title: "Clases de Alemán") do |post|
  post.description = <<-EOF
  Necesito practicar un Alemán básico, ya que me voy a Berlin a trabajar, por fin, he conseguido trabajo como ingeniero, me ayudas???
  EOF
  post.category_id = 5
  post.user_id = 1
  post.tags = ["Aleman", "Deutsche", "Conversación"]
  post.organization_id = 1
end

Document.find_or_create_by(label: "t&c") do |doc|
  doc.title = "Terminos de Servicio TimeOverflow"
  doc.content = <<-EOF
  TimeOverflow es un software libre desarrollado por voluntarios que tiene como finalidad facilitar, mediante tecnologías de la información, los procesos funcionales de un Banco de Tiempo. TimeOverflow permite la gestión de un Banco de Tiempo por parte de usuarios administradores y facilita el contacto entre todos los usuarios de un Banco de Tiempo.

  La Asociación para el Desarrollo de los Bancos de Tiempo, en adelante ADBdT, es una asociación sin ánimo de lucro que trabaja para desarrollar los Bancos de Tiempo. La ADBdT ofrece una instalación on-line de TimeOverflow y lo hace de manera gratuita para cualquier Banco de Tiempo que se lo solicite. El uso de esta aplicación on-line implica la aceptación previa, por parte de los administradores que gestionarán el Banco de Tiempo y de todos sus usuarios, de estos términos de servicio así como de sus futuras modificaciones.

  Ofrecemos esta aplicación on-line esperando que sea de gran utilidad para los Bancos de Tiempo, sin embargo no podemos ofrecer NINGUNA GARANTÍA sobre su correcto funcionamiento. La ADBdT mantiene esta instalación on-line gracias a las aportaciones de sus socios y seguirá ofreciendo este servicio siempre que le sea posible, en este sentido, se exime a la ADBdT de cualquier tipo de responsabilidad en cuanto al funcionamiento, así como sobre el acceso o disponibilidad de descarga de dicho programa.

  La ADBdT realiza copias de seguridad de la base de datos de TimeOverflow de manera regular con la finalidad de evitar posibles perdidas accidentales de datos y se compromete a atender cualquier incidencia, es por ello que con el uso de esta aplicación e inherente aceptación de estos términos de servicio, los Bancos del Tiempo reconocen haber obtenido el consentimiento expreso de cualquiera de sus socios y/o usuarios a los efectos de cesión y/o acceso de sus datos a terceros para poder atender a los servicios derivados del uso de TimeOverflow. Sin perjuicio de lo anterior, la ADBdT sólo accederá de manera puntual a los datos con finalidades estadísticas o técnicas manteniendo siempre el anonimato de los usuarios.

  La ADBdT no es responsable de la privacidad y protección de los datos de los usuarios de un Banco de Tiempo. Los responsables de los datos personales en un Banco de Tiempo son sus administradores, los cuales deben tener consentimiento expreso de sus usuarios y cumplir con la Ley Orgánica 15/1999, de 13 de diciembre de protección de datos. Cualquier divergencia que pudiera surgir con la ADBdT se someterá a la normativa española, así como se tratará ante los Juzgados y Tribunales de Barcelona, con renuncia expresa a cualquier otro fuero o norma que resultara de aplicación.

  Este servicio es ofrecido por la ADBdT con NIF:G65875031 que puede ser contactada en su dirección postal Carrer de la Providència, 42 (Hotel Entitats) 08024 Barcelona o bien mediante correo electrónico en adbdt.info@gmail.com
  EOF
end
