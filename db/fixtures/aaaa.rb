Organization.seed :id,
  id: 1, name: "TimeOverflow"

User.seed :email,
  email: "saverio.trioni@gmail.com",
  username: "admin",
  organization_id: 1,
  admin: true,
  superadmin: true,
  gender: "male",
  identity_document: "X0000000X"