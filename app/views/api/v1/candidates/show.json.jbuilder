json.candidate do
  json.partial! 'candidate', candidate: @candidate
  json.meta @meta
end
