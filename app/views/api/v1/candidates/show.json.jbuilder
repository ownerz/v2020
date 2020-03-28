json.candidate do
  json.partial! 'candidate_detail', candidate: @candidate
  json.meta @meta
end
